# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bankai is a Rails application template generator by 5xRuby (inspired by thoughtbot's Suspenders). It generates new Rails projects pre-configured with 5xRuby's standard tooling: Minitest, Rubocop, Overcommit, GitLab CI, and more.

The CLI entry point is `exe/bankai`, which invokes `Bankai::Generator`.

## Commands

```bash
# Install dependencies
bin/setup

# Run tests
bundle exec rake        # default task is :spec
bundle exec rspec       # direct invocation
bundle exec rspec spec/bankai_spec.rb  # single file

# Lint
bundle exec rubocop
bundle exec rubocop -a  # auto-correct

# Interactive console
bin/console

# Test the generator locally (creates a new Rails app using local bankai)
bankai myapp --path=/path/to/local/bankai
```

## Architecture

### Core Classes

- **`Bankai::Generator`** (`lib/bankai/generator.rb`) — Extends `Rails::Generators::AppGenerator`. Orchestrates the full project generation via the `customization` method, which calls steps in order: gemfile replacement, development environment setup, app configuration, dotfiles, sub-generators, and directory scaffolding.

- **`Bankai::Builder`** (`lib/bankai/builder.rb`) — Extends `Rails::AppBuilder`. Contains the actual file operations (template rendering, file copying, Rails config insertion) that the Generator delegates to via `build` calls.

- **`Bankai::Helper`** (`lib/bankai/helper.rb`) — Mixin providing database (`pg?`, `mysql?`) and deployment (`capistrano?`) detection by reading the generated Gemfile.

### Sub-Generators (`lib/bankai/generators/`)

Each sub-generator inherits from `Bankai::Generators::Base` and handles one concern (testing, CI, linting, JSON, DB optimizations, mailer, deploy, sitemap, whenever). They are invoked from `Generator#generate_default`.

### Templates (`templates/`)

ERB templates for generated project files (Gemfile, .rubocop.yml, .gitlab-ci.yml, etc.). Templates use conditional logic based on generator options (database type, API mode, capistrano flag).

## Key Options

The generator accepts: `--database` (postgresql/mysql2/sqlite3, default: sqlite3), `--capistrano`, `--skip-test`, `--skip-kamal` (default: true), `--skip-solid` (default: false), `--skip-thruster` (default: false), `--api`, `--path` (local gem path for testing).

## Rails Version Compatibility

- Supports Rails 8.0 and 8.1 only (Rails 7 support was dropped: falcon-rails requires Rails >= 8.0)
- Defaults: sqlite3 + Solid Queue/Cache/Cable + falcon-rails as the app server
- Tests are Minitest (Rails' default), with factory_bot + faker for data and DatabaseRewinder
  instead of transactional fixtures; `templates/test_helper.rb` replaces the one Rails generates
- Thruster is enabled by default and fronts Falcon; it is not Puma-specific (it proxies to
  whatever command it wraps, passing the backend port via `$PORT`). Kamal stays skipped
- `Builder#rewrite_dockerfile_cmd` rewrites Rails' Dockerfile `CMD`, which uses
  `bin/rails server`. That cannot run Falcon: falcon-rails deliberately avoids loading
  Falcon during boot, so the Rackup handler is unavailable and `rails server` reports
  "Could not find a server gem". Use `falcon serve` directly
- `templates/Gemfile.erb` replaces Rails' own Gemfile wholesale, so anything Rails declares in its Gemfile template (solid_*, kamal, rubocop-rails-omakase) must be repeated there
- `.rubocop.yml` inherits `rubocop-rails-omakase`; bankai writes it with `force: true` to overwrite the one Rails 8 generates
- Puma is filtered out of `gemfile_entries`; `Builder#remove_puma_config` deletes `config/puma.rb` and rewrites `bin/dev` to run `falcon serve`
- `inject_into_file` in sub-generators uses `Rails.application.configure do\n` as anchor
- `Bundler.with_unbundled_env` wraps sub-generator invocations and `rails_command` to prevent Bundler env leakage

## Testing Locally

```bash
# Build and install gem locally
rake install

# Generate a test app in /tmp
cd /tmp && bankai testapp --skip-rspec
```

## Conventions

- All Ruby files use `# frozen_string_literal: true`
- Version constants are in `lib/bankai/version.rb`
- Required Ruby version: >= 3.2.0; CI matrix is Ruby 3.2/3.3/3.4/4.0 x Rails 8.0/8.1
- Generated project README templates are in Traditional Chinese (zh-TW)
