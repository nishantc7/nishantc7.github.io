# Personal Website Redesign — Design Spec

**Date:** 2026-05-02
**Owner:** Nishant Choudhary
**Repo:** `nishantc7/nishantc7.github.io` (GitHub Pages, Jekyll)
**Inspiration:** Stitch "Architectural Minimalist" reference (`/stitch_the_engineering_ledger_prd/`)

## 1. Goal

Replace the bare-bones single-page site with a 4-page Jekyll portfolio styled in the "Architectural Minimalist" idiom. The site must signal senior-grade backend competence to technical recruiters: distributed systems, async pipelines, AI-augmented platforms.

## 2. Persona & Positioning

- **Name:** Nishant Choudhary
- **Headline:** Backend Engineer.
- **Tagline:** Building distributed systems, async pipelines, and AI-augmented platforms.
- **Current role:** Member of Technical Staff at ClearFeed (Oct 2025 – Present)
- **Prior:** Backend Developer at Ringover Group (Jun 2023 – Oct 2025), Backend Developer Intern at Ringover (Feb 2022 – May 2023)
- **Voice:** "Unspoken competence" — outcome-driven, no inflated titles, no buzzwords.

## 3. Information Architecture

Four pages, one shared layout, sticky top nav.

| Page | Path | Purpose |
|---|---|---|
| Home | `/` | Hero + selected experience + selected projects |
| Experience | `/experience/` | Full timeline of roles |
| Projects | `/projects/` | Categorized engineering work + open source |
| Writing | `/writing/` | Recent logbook + archive of old blog posts |

**Nav:** `NISHANT CHOUDHARY` (brand mark, small caps) · About · Experience · Projects · Writing · Email
**Footer:** `© 2026 NISHANT CHOUDHARY` · GitHub · LinkedIn

(Note: the "About" link in nav goes to `/#about` anchor on Home — no separate About page.)

## 4. Design System

Lifted from Stitch reference. Lock these values; do not adjust per page.

### Colors (monochrome, dark only)
- Background: `#0A0A0A`
- Primary text: `#EDEDED`
- Muted text: `#737373`
- Subtle text (body in lists): `#A3A3A3`
- Hairline borders: `#1A1A1A`
- Hover border: `#333333`

### Typography
- Font: **Inter** (Google Fonts), weights 300/400/500/700
- Display: 48px / 1.1 / -0.02em / 500
- H1: 24px / 1.2 / -0.01em / 500
- H2: 18px / 1.4 / -0.01em / 500
- Body-lg: 18px / 1.6 / 400
- Body-md: 15px / 1.6 / 400
- Label-caps: 12px / 1 / 0.1em / 500 / uppercase
- Metadata: 13px / 1.4 / 400
- Code (Logbook only): JetBrains Mono, 13px

### Spacing
- 8px base unit
- 32px element gap
- 64px small section gap
- 160px major section gap
- Container max-width: 720px
- Horizontal page padding: 32px

### Geometry & elevation
- Border-radius: **0px everywhere** (sharp)
- Box-shadow: **none, anywhere**
- Backdrop blur: **none**
- Differentiation only via 1px hairline borders (`#1A1A1A`) or text color shifts

## 5. Page Specs

### 5.1 Home (`index.html`)

```
[NAV: sticky, h-20, hairline bottom border]

[hero — pt-64, mb-160]
  SUBHRAJIT-style label-caps: NISHANT CHOUDHARY
  Display: Backend Engineer.
  Body-lg muted: Building distributed systems, async pipelines, and
                 AI-augmented platforms. Currently at ClearFeed; previously
                 ~3.5 years at Ringover Group.
  [GITHUB · LINKEDIN · RESUME]   ← small-caps links, hairline underline

[Selected Experience — mb-160]
  hairline-top + label-caps section header
  3 entries: role + sub-line + dates, hairline divider after each
    - Member of Technical Staff · ClearFeed · Oct 2025 — Present
    - Backend Developer · Ringover Group · Jun 2023 — Oct 2025
    - Backend Developer Intern · Ringover Group · Feb 2022 — May 2023
  Each row links to /experience#anchor

[Selected Projects — mb-160]
  hairline-top + label-caps section header: SELECTED ENGINEERING WORK
  3 highlight projects (h2 title + 2-line muted description + READ MORE → link to /projects#anchor):
    - SQS Worker Pipeline Hardening
    - Webhooks Go Service Rewrite (PHP → Go)
    - Ringover Webhooks Go SDK (open source)

[FOOTER]
```

**Hero "RESUME" link:** opens `https://drive.google.com/file/d/1cmeY4ciM100keLUXtFlDOpOOmGYx7YbE/view` in a new tab. No PDF in repo.

### 5.2 Experience (`/experience/`)

Vertical timeline with 1px line on left + dot markers per entry. Three entries, content drawn from `Pasted text.txt` and condensed to 2-3 outcome bullets per role.

**Entry 1 — ClearFeed · Member of Technical Staff · Oct 2025 – Present**
- Owned end-to-end delivery of 10+ enterprise features on a Slack-based support automation platform — product spec → build → release manager → on-call. Direct collaboration with the CTO; ~$70k ARR contribution.
- Hardened SQS-backed async worker pipeline with payload validation, idempotency keys, and structured DLQ handling — cut worker failure rate by 65% and eliminated silent message loss in production.
- Tightened the AI Agent's RAG and query-restriction layers (classification filters, prompt guardrails, retrieval tuning) — reduced agent escalations by 30%.

**Entry 2 — Ringover Group · Backend Developer · Jun 2023 – Oct 2025**
- Independently shipped the Statistics Service for the Sales Prospecting Tool — ETL pipeline consolidating data into TiFlash columnar storage. Cut response time 78%, saved ~$2,500/month in infra, with multi-timezone correctness built in.
- Rebuilt webhook processing in Go to replace a PHP bottleneck — typed schemas across 15+ events, per-resource HMAC verification, real-time smart routing. Cut webhook latency ~40% and eliminated production delivery failures.
- Built Ringover's first automated email delivery service from scratch — multi-provider (Gmail/Outlook) over Node.js + gRPC with queue-based retries. 99.5% delivery success across thousands of daily emails.

**Entry 3 — Ringover Group · Backend Developer Intern · Feb 2022 – May 2023**
- Implemented Redis-backed middleware for caching auth tokens and tracking 100k+ daily external CRM API calls — prevented Salesforce/Pipedrive rate-limit breaches and cut redundant auth overhead by 30% CPU.
- Designed bidirectional CRM sync with Salesforce/Pipedrive over RabbitMQ async processing with conflict resolution — cut sync errors by 90%.

### 5.3 Projects (`/projects/`)

Grouped by domain. Each item: H2 title (linked or not), 2-3 line muted description, optional `[Company / Year]` metadata in label-caps.

**Distributed Systems & Async Pipelines (4)**
1. **SQS Worker Pipeline Hardening** — ClearFeed · 2025-2026
2. **Statistics Service ETL** — Ringover · 2024
3. **Webhooks Go Service** — Ringover · 2024
4. **Automated Email Delivery Service** — Ringover · 2023-2024

**APIs & Integrations (4)**
1. **Enterprise Bulk Import API** — ClearFeed · 2025-2026
2. **A2P 10DLC Compliance & TCR Registration** — Ringover · 2024
3. **Bidirectional CRM Sync (Salesforce / Pipedrive)** — Ringover · 2022-2023
4. **Redis Auth-Cache & Rate-Visibility Middleware** — Ringover · 2022-2023

**AI & Platform Features (2)**
1. **AI Agent Query Restriction & RAG Tuning** — ClearFeed · 2025-2026
2. **Cross-Thread Ticket Merge** — ClearFeed · 2025-2026

**Open Source (1)**
1. **Ringover Webhooks Go SDK** — Personal · Jul 2025 — link to GitHub repo

Section header pattern: hairline-top divider, label-caps category name, `XX Entries` counter on the right (matching Stitch).

### 5.4 Writing (`/writing/`)

```
[Header]
  Display: Logbook
  Body-lg muted: A chronological feed of engineering notes,
                 architecture decisions, and reading.

[Recent — empty for now]
  Renders Jekyll posts dated 2024+ (none yet — placeholder text:
    "First entry coming soon.")

[hairline divider, label-caps: ARCHIVE]
[Archive feed]
  - Jul 6, 2020 — Random Anime Reviews
    "First blog from 2020 — recommendations on Kimi no Na wa,
    Haikyuu, Re:Zero, and more."
    READ ENTRY →
```

The archive entry is a single Jekyll post at `_posts/2020-07-06-random-anime-reviews.md`, content migrated from the old `gatsby-blog` repo's `anime.md`. The post page reuses the same layout — same nav, same footer, same 720px container. Markdown rendered by Jekyll (kramdown) with images preserved.

## 6. Implementation

### 6.1 Stack
- **Jekyll** (already configured for GitHub Pages)
- **Plain HTML** templates, **handwritten CSS** (~200 lines, no preprocessor)
- **No JavaScript** — zero client-side runtime
- **Inter** + optionally **JetBrains Mono** via Google Fonts `<link>` tags
- **Kramdown** for Markdown (Jekyll default)

### 6.2 File layout
```
nishantc7.github.io/
├── _config.yml                # site vars; remove jekyll-theme-minimal
├── _layouts/
│   ├── default.html           # nav + content slot + footer
│   └── post.html              # extends default, adds post title/date
├── _includes/
│   ├── head.html              # <meta>, fonts, CSS
│   ├── nav.html               # sticky top nav
│   └── footer.html
├── _posts/
│   └── 2020-07-06-random-anime-reviews.md
├── assets/
│   └── css/main.css
├── index.html                 # Home
├── experience.html            # `permalink: /experience/`
├── projects.html              # `permalink: /projects/`
├── writing.html               # `permalink: /writing/`
├── docs/superpowers/specs/    # this spec lives here
└── README.md
```

### 6.3 _config.yml
```yaml
title: Nishant Choudhary
description: Backend Engineer building distributed systems, async pipelines, and AI-augmented platforms.
url: https://nishantc7.github.io
author:
  name: Nishant Choudhary
  email: nishant.choudh4ry.7@gmail.com
  github: nishantc7
markdown: kramdown
permalink: /writing/:year/:month/:day/:title/
```

(No `theme:` line — handwritten layouts override the minimal theme.)

### 6.4 CSS architecture
- Single `assets/css/main.css`, ~200 lines
- CSS custom properties for the palette + spacing tokens
- Mobile breakpoint at 720px:
  - Nav links stack horizontally still (4 items fit), but font shrinks to 13px
  - Hero display drops 48px → 36px
  - Section gaps drop 160px → 96px
- No CSS framework, no JS

### 6.5 What to delete from current repo
- `main.css` at root (replaced by `assets/css/main.css`)
- `index.html` content (replaced)
- `README.md` (replace with one-line site description)

## 7. Out of scope (YAGNI)

- Light mode / theme toggle
- About page (collapsed into Home hero)
- Hero "visual anchor" image (Stitch placeholder cut)
- Material Symbols icon font (inline `→` Unicode used)
- Tailwind / any CSS framework (handwritten)
- Custom domain
- RSS feed
- Analytics / tracking
- Local copy of resume PDF (RESUME button links to Google Drive URL)

## 8. External Links Reference

- **Resume:** https://drive.google.com/file/d/1cmeY4ciM100keLUXtFlDOpOOmGYx7YbE/view
- **GitHub:** https://github.com/nishantc7
- **Email:** nishant.choudh4ry.7@gmail.com
- **LinkedIn:** https://www.linkedin.com/in/nishantchoudhary7/
- **Old Gatsby blog source:** https://github.com/nishantc7/gatsby-blog

## 9. Acceptance Criteria

- [ ] All four pages render at root paths via `bundle exec jekyll serve`
- [ ] Nav links work between pages; active state highlights current page
- [ ] Mobile viewport (≤640px) renders without horizontal scroll
- [ ] RESUME link opens Google Drive in new tab
- [ ] Anime archive post renders with images intact
- [ ] No 404s; no console errors; no JS bundle
- [ ] Lighthouse Performance ≥ 95 (no JS framework, no large images, monochrome only)
- [ ] Page weight per route < 100KB total (HTML + CSS + fonts)
