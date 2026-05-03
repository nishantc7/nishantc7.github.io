---
layout: post
title: Audit logs at ClearFeed
date: 2026-04-09
description: "The decisions behind ClearFeed's audit logging system — why async dispatch, why a listener in the middle, why batching, and how export works at scale."
---

I owned ClearFeed's audit logging system. It runs across all accounts, handles 10,000+ events a day, and backs the CSV exports enterprise customers hand to their auditors. This is about the decisions that shaped it and why I made them.

## Keeping it off the request path

The obvious implementation is writing audit rows directly from request handlers into Postgres. It works until large account actions start fanning out to hundreds of audit events, or bulk imports fire thousands at once. Every customer action ends up waiting on Postgres.

Audit logging cannot slow down or fail a user request. That ruled out synchronous writes from the start.

## Why a dispatcher instead of calling the queue directly

Once you go async, the natural move is calling `writeQueue.add()` wherever an audit event happens. But across 30 services, that spreads a BullMQ/Redis dependency through the entire codebase. Every caller knows they are talking to a queue. Swapping the transport, adding filtering, or dropping low-priority events during an incident means touching 30 places.

A dispatcher gives callers one thing to do: describe what happened. They do not know or care whether the log goes to a queue, a database, or nowhere. The transport is the dispatcher's problem.

## Why an async listener in the middle

There is an async listener between the dispatcher and the queue processor. Its job is to normalize each event before it gets queued: actor metadata, resource IDs, operation type, timestamps, request source, workspace context. All of that happens in one place.

Capturing what happened and writing it durably to the database are two separate jobs. Keeping them separate also means any cross-cutting logic goes into the listener and nowhere else. Enrichment, filtering, dropping low-priority events entirely. Neither the dispatcher nor the processor needs to know about any of it.

BullMQ (backed by Redis) gives the queue its durability. If Postgres is slow or unavailable, jobs wait in Redis and retry automatically rather than being lost or surfacing as errors to the user.

## Why cursor-based pagination instead of page numbers

The list endpoint uses a cursor, not page numbers. Audit logs are append-only and constantly growing. With offset pagination, new rows shift page positions while someone paginates. Page 2 starts including entries they already saw on page 1, or skips some entirely.

A cursor holds a fixed position in the log. New entries arriving in the background do not change where you are. For a system that receives new events continuously, this is the only pagination approach that stays consistent.

## Why `details` is a flexible JSON field instead of fixed columns

Each action type has different context. A field update records what changed and what it changed from. A resource access records that someone looked at something. These shapes are not the same, and there is no sensible way to put them into fixed columns without wasting most of those columns most of the time, or running schema migrations every time a new action type gets added.

`details` is a structured JSON blob that varies by action. It is always serialized deterministically so downstream tooling gets consistent output. The tradeoff is that you cannot filter on fields inside it at the database level, but that is fine because `details` is for context, not for querying. Everything you would actually filter on sits in its own indexed column.

## Why `source` is its own column

The `source` field tracks where an action came from: API, Dashboard, or Slack. Burying this inside `details` was tempting early on because it felt like metadata. It is not metadata. It is something compliance reviewers filter on.

A bulk delete from the API looks different from the same delete from the Dashboard. If `source` lives inside a JSON blob, you cannot query for it. Pulling it out as an indexed column costs almost nothing and makes it queryable like any other filter.

## Why batch writes

At volume, individual INSERTs become a problem. Each one carries connection overhead, transaction overhead, and index update cost. `bulkCreate` amortizes all of that across N rows in a single statement.

Under normal load the processor flushes on a time threshold anyway, so writes are not delayed. The batch size exists to prevent the database from becoming a bottleneck during spikes.

I also indexed only the fields the API actually filters on: actor email, operation type, resource type, source, timestamps. The write path stayed fast and query performance stayed predictable as the table grew.

## Why CSV for export

Compliance and security teams do not work inside your product. They pull audit data into spreadsheets, SIEM systems, internal dashboards. CSV is what people use when they are doing offline analysis or handing records to an auditor.

The export had to stream. Loading a full result set into memory fails on large accounts with wide date ranges. The exporter reads in batches and writes directly to the CSV stream, so memory usage stays flat regardless of export size.

## The operational details

Behind AWS ALB (Application Load Balancer), the real client IP is in `X-Forwarded-For`, not the socket address. That one took a moment to catch.

Slack-originated actions store a null IP.

Async retries carry actor context forward. A delayed job needs to map back to the original user who triggered it, not appear as anonymous system activity when it eventually processes.

## What it became

The system started as logging infrastructure. Once customers started depending on it for security reviews and compliance workflows, it became a production data path with the same reliability expectations as the rest of the product. That shift happened faster than expected.
