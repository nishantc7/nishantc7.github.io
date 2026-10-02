# nishantc7.github.io

Personal website of Nishant Choudhary — Backend Engineer.

Live: https://nishantc7.github.io

## Local development

```sh
bundle install
bundle exec jekyll serve
```

Open http://localhost:4000.

## Structure

```
_layouts/    Default page + post layouts
_includes/   Shared header, nav, footer partials
_posts/      Logbook entries (Markdown, dated)
assets/css/  Single handwritten CSS file
*.html       Top-level pages: index, experience, projects, writing
docs/        Design specs (excluded from build)
```

No JS, no CSS framework, no build step beyond Jekyll.

## Quick add (owner only)

Open https://github.com/nishantc7/nishantc7.github.io/actions/workflows/add-reading.yml
while signed in as `nishantc7`. Click **Run workflow**, keep branch **master**, paste
just the HTTPS URL, and submit. Title, note, publication name, HN discussion
and date are optional. A URL-only submission displays a bare clickable link.
The date defaults to today in India for sorting. A green workflow means the link has been published. Bookmark this page
on your phone for quick access.

The workflow only runs for `nishantc7` on `master`, including re-runs. Public visitors
cannot submit. Repository write/admin permissions still control direct file edits.
Submitting the same URL updates it. For removal, edit `_data/reading.yml` below.
Concurrent submissions are serialized; GitHub keeps only one pending run, so wait
for a submission to finish before sending the next.

## Sharing an article manually

Edit `_data/reading.yml`. Replace `[]` with your first entry, then append entries:

```yaml
- url: "https://example.com/article"
  title: "Article title" # Optional
  source: "Publication name" # Optional
  date: "2026-10-02" # Date you shared it, YYYY-MM-DD
  note: "Why I found this interesting." # Optional, plain text
  discussion: "https://news.ycombinator.com/item?id=123" # Optional
```

Use HTTPS links. Both pages sort by date, newest first. The homepage shows
three entries; `/reading/` shows all of them. Title, source, notes and discussion
links are optional. Omit them all for a bare link. No sample articles are published. Keep every date in YYYY-MM-DD format.

## Previewing a change

Pull requests build with Jekyll and upload a `website-preview` artifact for review.
For a separate GitHub Pages preview repository named `website-preview`, build with
`bundle exec jekyll build --baseurl /website-preview`. Publish the resulting
`_site` contents there, with an empty `.nojekyll` file. Configure that repository's
Pages source to its publishing branch. The production repository continues to
publish only changes merged to `master`.

This alternative preview uses `/website-preview/v2/` and retains the first preview at `/website-preview/`.
