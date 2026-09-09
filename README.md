Bankai
===

This gem is inspired by [Suspenders](https://github.com/thoughtbot/suspenders) for [5xRuby](https://5xruby.tw) to bootstrap a rails project.

## Installation

First, install bankai

```
gem install bankai
```

The bootstrap your rails project

```
bankai projectname
```

## Requirement

* Ruby >= 3.2.0
* `>= 1.0` requires `rails >= 8.0` (tested against Rails 8.0 and 8.1)
* `~> 0.13` required `rails >= 7.0`
* `<= 0.12` required `rails >= 5.2`

See [CHANGELOG.md](CHANGELOG.md) for what changed in 1.0.

## Gemfile

* [Oj](http://www.ohler.com/oj/)
* [Falcon](https://github.com/socketry/falcon-rails) - app server (replaces Puma)

### Development

* [Brakeman](https://github.com/presidentbeef/brakeman)
* [Bundler Audit](https://github.com/rubysec/bundler-audit)
* [Rubocop](https://github.com/rubocop/rubocop) - inherits [rubocop-rails-omakase](https://github.com/rails/rubocop-rails-omakase)
* [Rack Mini Profiler](https://github.com/MiniProfiler/rack-mini-profiler) - Enable with `RACK_MINI_PROFILER=1`
* [AnnotateRb](https://github.com/drwl/annotaterb)
* [Bullet](https://github.com/flyerhzm/bullet)
* [Dotenv](https://github.com/bkeepers/dotenv)
* [Letter Opener](https://github.com/ryanb/letter_opener)
* [Overcommit](https://github.com/brigade/overcommit)
* [Pry Rails](https://github.com/rweng/pry-rails)

### Test

* [Minitest](https://guides.rubyonrails.org/testing.html) - Rails' built-in test framework
* [Capybara](https://github.com/teamcapybara/capybara)
* [Factory Bot](https://github.com/thoughtbot/factory_bot)
* [Faker](https://github.com/faker-ruby/faker)
* [Shoulda Context](https://github.com/thoughtbot/shoulda-context)
* [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers)
* [Database Rewinder](https://github.com/amatsuda/database_rewinder)
* [Simplecov](https://github.com/colszowka/simplecov) - Enable with `COVERAGE=1`

## Others

* Configured `.gitlab-ci.yml`
* Auto filled capistrano configure

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Test Gem

To try your local changes, run `exe/bankai` straight out of the checkout and
point `--path` at that same checkout:

```
cd /somewhere/else
ruby /path/to/bankai/exe/bankai projectname --path=/path/to/bankai
```

Both parts matter, and they do different things:

* which `exe/bankai` you run decides whose `lib/` and `templates/` generate the app
* `--path` decides which bankai the **generated app** bundles, and therefore
  which version runs the `bankai:*` sub-generators (testing, ci, lint, ...)

Without `--path` the generated Gemfile asks for the released
`gem 'bankai', '~> <major>.<minor>'`, so an unreleased version fails at
`bundle install` rather than silently running an older gem's sub-generators.

Do not run this from inside the bankai repo, and do not set `BUNDLE_GEMFILE` —
the generated app's `bundle install` would then resolve against bankai's own
Gemfile.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/5xRuby/bankai. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Bankai project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/5xRuby/bankai/blob/master/CODE_OF_CONDUCT.md).
