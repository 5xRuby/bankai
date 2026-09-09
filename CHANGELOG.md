# Changelog

All notable changes to this project are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Releases before 1.0.0 are not listed; see the [git tags](https://github.com/5xRuby/bankai/tags)
for that history.

## [Unreleased]

## [1.0.0] - 2026-09-09

The generated stack changed substantially and Rails 7 is no longer supported,
so this release is not backwards compatible with `0.14`.

### Changed

- **Default database is now `sqlite3`** (was `postgresql`).
- **Solid Queue / Cache / Cable are installed by default** — `--skip-solid` now
  defaults to `false`.
- **Falcon replaces Puma as the app server.** `puma` is filtered out of the
  Gemfile, `config/puma.rb` is removed, and `bin/dev` runs
  `falcon serve --bind http://localhost:3000 --count 1`.
- **Generated projects use Minitest instead of RSpec.** The surrounding tooling
  is unchanged: `factory_bot_rails`, `faker`, `shoulda-matchers`,
  `database_rewinder`, `simplecov` and `simplecov-cobertura`. `shoulda-context`
  is added so the `should` macro is available. Note that fixtures are not used:
  DatabaseRewinder truncates every table, which conflicts with `fixtures :all`,
  so `use_transactional_tests` is off and test data comes from factories.
- **`.rubocop.yml` inherits `rubocop-rails-omakase`** instead of carrying
  bankai's own cop list, and is written with `force: true` to overwrite the one
  Rails generates. `rubocop-rspec` is replaced by `rubocop-minitest`.
- `annotate` (unmaintained) is replaced by `annotaterb`.
- `.gitlab-ci.yml` runs `bin/rails test`, and only declares `services:` when
  PostgreSQL or MySQL is actually in use.
- Scaffolded directories are now `test/factories`, `test/requests` and
  `test/support/{matchers,mixins}`.
- Development dependencies were unpinned from ancient versions (`rake ~> 13`,
  `rubocop ~> 1.90`, `simplecov ~> 0.22`) so `bundle exec` works on Ruby 4.0.

### Removed

- **Rails 7 support.** The gem now requires `rails >= 8.0.0`; the CI matrix is
  Ruby 3.2/3.3/3.4/4.0 x Rails 8.0/8.1. `falcon-rails` requires Rails >= 8.0,
  so Rails 7 could only ever have run on a degraded path.
- The `--skip-rspec` option. Use `--skip-test` (default `false`) instead.
- The `RUBOCOP_VERSION` constant, now that RuboCop is not version-pinned in the
  Gemfile template.
- Dead version branches: the `SUPPORTED_DATABASES` fallback chain, the
  pre-Rails-6 `app_name` branch, and the `options.skip_yarn?` block in the
  gitignore template.

### Fixed

- `exe/bankai` computed its load path as `"#{dirname}../lib"`, missing a
  separator, and appended rather than prepended it — so running it from a
  checkout silently used the *installed* bankai gem, making local generator
  changes untestable.
- `TargetRubyVersion: <%= RUBY_VERSION %>` in the RuboCop template produced
  `4.0.6` on Ruby 4.0, which RuboCop rejects (it only accepts `major.minor`),
  breaking RuboCop in every generated project.
- `templates/Gemfile.erb` replaces Rails' own Gemfile template wholesale, which
  silently dropped everything Rails declares there (`solid_*`, `kamal`,
  `rubocop-rails-omakase`). Those are now declared by bankai.
- Deprecated Bundler platform names (`%i[mingw mswin x64_mingw]`) are now
  `%i[windows jruby]` / `%i[mri windows]`.
- The deprecated `SimpleCov.add_filter` call is now `SimpleCov.skip`.
- Rails' Dockerfile `CMD` is rewritten to run `falcon serve`. It shipped as
  `bin/rails server`, which cannot start Falcon — falcon-rails deliberately does
  not load Falcon during boot, so the Rackup handler is unavailable and
  `rails server` fails with "Could not find a server gem" — meaning the
  generated Dockerfile would not have booted at all. With `--no-skip-thruster`
  the `CMD` becomes `./bin/thrust sh -c 'exec ... --bind http://0.0.0.0:$PORT'`,
  so `$PORT` expands in the shell Thruster starts rather than in one wrapping it.
- `gem "thruster"` is declared in the Gemfile template, so `--no-skip-thruster`
  actually installs it (same omission as `solid_*` and `kamal`).
- The generated Gemfile now pins `gem 'bankai', '~> <major>.<minor>'`. It was
  unpinned, so running an unreleased `exe/bankai` without `--path` silently
  bundled an older published bankai and ran *its* `bankai:*` sub-generators;
  now `bundle install` fails instead. `--path` replaces the whole line, since a
  path source and a version requirement cannot both be given.

[Unreleased]: https://github.com/5xRuby/bankai/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/5xRuby/bankai/compare/v0.14.0...v1.0.0
