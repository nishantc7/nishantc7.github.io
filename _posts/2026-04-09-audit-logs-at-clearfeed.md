---
layout: post
title: Audit logs at ClearFeed
date: 2026-04-09
description: "The decisions behind ClearFeed's audit logging system — why async dispatch, why a listener in the middle, why batching, and how export works at scale."
tags: [engineering, work]
---

I owned ClearFeed's audit logging system. It runs across all accounts, handles 10,000+ events a day, and backs the CSV exports enterprise customers hand to their auditors. This is about the decisions that shaped it and why I made them.

## Keeping it off the request path

My first instinct was to write audit rows directly from request handlers into Postgres. It works until large account actions start fanning out to hundreds of audit events, or bulk imports fire thousands at once. Every customer action ends up waiting on Postgres.

Audit logging cannot slow down or fail a user request. That ruled out synchronous writes from the start.

## The dispatcher abstraction

Once you go async, the natural move is calling `writeQueue.add()` wherever an audit event happens. But across 30 services, that spreads a BullMQ/Redis dependency through the codebase. Every caller knows they are talking to a queue.

A dispatcher gives callers one thing to do: describe what happened.

```ts
audit.dispatch(...)
```

The caller does not know where the event goes next. Queueing, persistence, filtering, and retries stay outside the business logic. Services only describe what happened and move on.

## Processing audit events

The dispatcher only publishes that something happened. The audit worker is responsible for turning that into an audit record.

Different actions produce different audit records. A user update records changed fields. A resource access records who viewed what. A bulk operation may generate several audit entries from a single event. Keeping that logic in one place avoided audit-specific code leaking into request handlers.

BullMQ (backed by Redis) provides the buffer between the application and Postgres. If the database is slow or unavailable, jobs wait in Redis and retry automatically rather than slowing down user requests.

## Pagination

The list endpoint uses a cursor, not page numbers. Audit logs are append-only and constantly growing. With offset pagination, new rows shift page positions while someone paginates. Page 2 starts including entries they already saw on page 1, or skips some entirely.

A cursor holds a fixed position in the log. New entries arriving in the background do not change where you are. For a system that keeps growing, cursor pagination ended up being the most reliable option.

## The shape of an audit record

Each action type has different context. A field update records what changed and what it changed from. A resource access records that someone looked at something. These shapes are not the same, and there is no sensible way to put them into fixed columns without wasting most of those columns most of the time, or running schema migrations every time a new action type gets added.

`details` is a structured JSON blob that varies by action. It is always serialized deterministically so downstream tooling gets consistent output. The tradeoff is that querying inside `details` becomes harder, but that is fine because `details` is for context, not for querying. Everything you would actually filter on sits in its own indexed column.

## Making source queryable

The `source` field tracks where an action came from: API, Dashboard, or Slack. I considered keeping it inside `details` early on because it looked cleaner.

A bulk delete from the API looks different from the same delete from the Dashboard. If `source` lives inside a JSON blob, you cannot query for it efficiently. Pulling it out as an indexed column costs almost nothing and makes it queryable like any other filter.

## Handling write volume

Writing every audit record individually worked at first. As volume grew, the database spent more time handling connection overhead, transaction overhead, and index updates than the writes themselves.

The worker processes audit events in batches and writes them using a single bulk INSERT. Bulk writes amortize those costs across many rows in a single statement.

Under normal load, batches stay small. During spikes, batching prevents the database from becoming the bottleneck while keeping write throughput predictable.

I also indexed only the fields the API actually filters on: actor email, operation type, resource type, source, timestamps. The write path stayed fast and query performance stayed predictable as the table grew.

## Exporting data

Compliance and security teams do not work inside your product. They pull audit data into spreadsheets, SIEM systems, internal dashboards. CSV is what people use when they are doing offline analysis or handing records to an auditor.

The export had to stream. Loading a full result set into memory fails on large accounts with wide date ranges. The exporter reads in batches and writes directly to the CSV stream. That kept memory usage predictable even for large exports.

## The operational details

Behind AWS ALB (Application Load Balancer), the real client IP is in `X-Forwarded-For`, not the socket address. That one took a moment to catch.

Slack-originated actions store a null IP.

Async retries carry actor context forward. A delayed job needs to map back to the original user who triggered it, not appear as anonymous system activity when it eventually processes.

## What it became

The system started as logging infrastructure. Once customers started depending on it for security reviews and compliance workflows, it became a production data path with the same reliability expectations as the rest of the product.
