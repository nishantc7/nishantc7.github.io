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

## Sharing an article

Edit `_data/reading.yml`. Replace `[]` with your first entry, then append entries:

```yaml
- title: "Article title"
  url: "https://example.com/article"
  source: "Publication name"
  date: "2026-10-02" # Date you shared it, YYYY-MM-DD
  note: "Why I found this interesting." # Optional, plain text
  discussion: "https://news.ycombinator.com/item?id=123" # Optional
```

Use HTTPS links. Both pages sort by date, newest first. The homepage shows
three entries; `/reading/` shows all of them. Notes and discussion links are
optional. No sample articles are published. Keep every date in YYYY-MM-DD format.

## Previewing a change

Pull requests build with Jekyll and upload a `website-preview` artifact for review.
For a separate GitHub Pages preview repository named `website-preview`, build with
`bundle exec jekyll build --baseurl /website-preview`. Publish the resulting
`_site` contents there, with an empty `.nojekyll` file. Configure that repository's
Pages source to its publishing branch. The production repository continues to
publish only changes merged to `master`.

This alternative preview uses `/website-preview/v2/` and retains the first preview at `/website-preview/`.
