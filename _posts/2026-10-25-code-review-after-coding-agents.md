---
layout: post
title: Code review after coding agents
date: 2026-10-25
tags: [engineering]
---

**TL;DR:** A year back, I used to read the diff for every line. Now I use a [skill](https://github.com/nishantc7/skills) to get a review page made for every PR. It highlights the important changes and writes pseudocode for them, so I don't read through the diff for every file.

By important changes, I mean code with a high blast radius: code that can hurt many users, or do damage that is hard to undo, if it is wrong.

A skill is a set of written instructions that a coding agent such as Claude Code loads and follows for one kind of task. This one tells the agent how to review a pull request.

The examples below come from the review page for an example PR. The full page is [here](https://raw.githack.com/nishantc7/skills/main/reviewing-pr-decisions/example-review.html).

## The pattern

The way to do it is to get AI to help me follow a pattern for reading PRs: skim first using the flowcharts, then read the pseudocode for the new or changed logic that matters.

First, there's the flowchart. It gives me an overview of the flows and how they've changed. This helps me see which parts are critical and need more focus when I go through the code.

![A before and after flowchart. Checkout, receipt emails and partner webhooks all use a shared HTTP client. After the change, the client tries up to 3 times, so a card can be charged twice, a receipt can arrive 3 times, and a partner can get an event 3 times.]({{ "/assets/img/how-to-review-code/review-flowchart.png" | relative_url }})

*The example PR adds retries to fix failed payments. It adds them to the shared HTTP client, so receipt emails and partner webhooks retry too. That is the part to read first.*

Then I can pick up individual changes and read the pseudocode for them.

![Pseudocode, before and after. The shared HTTP client now defaults to 3 attempts. The receipt email code is not in the diff, but it now retries too, so a customer can get up to 3 receipts.]({{ "/assets/img/how-to-review-code/review-pseudocode.png" | relative_url }})

When a change edits a function that other code calls, the page lists those callers and counts them. That makes the blast radius easy to see before I read any code.

I was building an integration into one of our most used flows. The review page listed every outside call the change made, and one of them went to an integration we had retired months earlier. The call sat in a helper the new code reused, so the diff never showed it. Reading file by file, I would have missed it.

## The workflow

1. Plan properly. I make the architectural decisions, like the system design, before any code is written. Below that level, I tell the agent the what, not the how. The whole SDLC (software development life cycle: design, build, test, review and ship) lives inside the plan. Then grill the plan before building, and then build. To grill a plan, I ask the agent to question me about it, one decision at a time, until nothing is left unclear.
2. The agent must test its own code in a dev environment. Visual changes are tested through emulators, plus throwaway instances when needed.
3. Use the review skill to review the PR's decisions instead of reading the diffs. A decision is a choice the agent made where the ticket did not say what to do, such as a timeout, a default or a filter.

The skill also starts an independent reviewer that never sees the main review. It looks for security and performance problems separately.

This is the framework to move fast and still be responsible for what I ship.

## What I give up

I also trade some codebase hygiene for velocity. Specifically:

- Duplicated code
- Neater types
- Variable names

A year ago, I reviewed every line of code that went into production. Even if it was a test with a variable name that could be improved, I would change it. Honestly, I don't think that is required anymore.

For me, it's enough if I can understand the change at the level of the arrows in a diagram, the change is well tested, it helps me move faster, and the code won't be hard to change in a month.

I still read the diff line by line when a change moves money, sends emails, deletes data, changes a login check or runs a database migration.

## Try it

[github.com/nishantc7/skills](https://github.com/nishantc7/skills)

Copy `reviewing-pr-decisions` into `~/.claude/skills/` and ask your agent to review a PR.
