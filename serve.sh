#!/usr/bin/env bash
#
# Preview the site locally at http://localhost:4000 — no Ruby setup needed.
#
#   ./serve.sh
#
# This runs Jekyll inside Docker (which you already have installed), so you
# never have to deal with Ruby versions or compiling gems. Just make sure
# Docker Desktop is running first.
#
# First run downloads the gems (a few minutes); later runs start in seconds.
# Edit any .md or .scss file, save, and the page reloads automatically.
# Press Ctrl+C to stop.
#
# _config_dev.yml keeps asset/link paths local so you see YOUR edits; GitHub
# Pages ignores it, so the live site is unaffected.

set -e
cd "$(dirname "$0")"

if ! docker info >/dev/null 2>&1; then
  echo "Docker isn't running. Open Docker Desktop, wait for it to start, then re-run ./serve.sh"
  exit 1
fi

# JEKYLL_ENV=production stops `jekyll serve` from rewriting every asset URL to
# http://0.0.0.0:4000 (which browsers refuse to load). With it, asset paths stay
# root-relative (/assets/...) and load correctly at http://localhost:4000.
exec docker run --rm -it \
  -e JEKYLL_ENV=production \
  -v "$PWD":/srv/jekyll \
  -v jekyll-bundle:/usr/local/bundle \
  -p 4000:4000 -p 35729:35729 \
  -w /srv/jekyll \
  ruby:3.2 \
  bash -lc "bundle install && bundle exec jekyll serve --host 0.0.0.0 --livereload --force_polling --config _config.yml,_config_dev.yml"
