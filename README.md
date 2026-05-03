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
