# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bankai is a Rails application template generator by 5xRuby (inspired by thoughtbot's Suspenders). It generates new Rails projects pre-configured with 5xRuby's standard tooling: RSpec, Rubocop, Overcommit, GitLab CI, and more.

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

The generator accepts: `--database` (postgresql/mysql2/sqlite3, default: postgresql), `--capistrano`, `--skip-rspec`, `--api`, `--path` (local gem path for testing).

## Conventions

- All Ruby files use `# frozen_string_literal: true`
- Version constants are in `lib/bankai/version.rb`
- Generated project README templates are in Traditional Chinese (zh-TW)
