Ruby5x
===

This gem is inspired by [Suspenders](https://github.com/thoughtbot/suspenders) for [5xRuby](https://5xruby.tw) to bootstrap a rails project.

## Installation

First, install rb5

```
gem install rb5
```

The bootstrap your rails project

```
rb5 projectname
```

## Gemfile

* [Oj](http://www.ohler.com/oj/)

### Development

* [Brakeman](https://github.com/presidentbeef/brakeman)
* [Bundler Audit](https://github.com/rubysec/bundler-audit)
* [Rubocop](https://github.com/bbatsov/rubocop)
* [Rack Mini Profiler](https://github.com/MiniProfiler/rack-mini-profiler) - Enable with `RACK_MINI_PROFILER=1`
* [Annotate](https://github.com/ctran/annotate_models)
* [Bullet](https://github.com/flyerhzm/bullet)
* [Dotenv](https://github.com/bkeepers/dotenv)
* [Letter Opener](https://github.com/ryanb/letter_opener)
* [Overcommit](https://github.com/brigade/overcommit)
* [Pry Rails](https://github.com/rweng/pry-rails)

### Test

* [Capybara](https://github.com/jnicklas/capybara)
* [Google Chromedriver](https://sites.google.com/a/chromium.org/chromedriver/home)
* [Factory Bot](https://github.com/thoughtbot/factory_bot)
* [Faker](https://github.com/stympy/faker)
* [Rspec](https://github.com/rspec/rspec)
* [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers)
* [Simplecov](https://github.com/colszowka/simplecov) - Enable with `COVERAGE=1`

## Others

* Configured `.gitlab-ci.yml`
* Auto filled capistrano configure

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Test Gem

If you want to test the changes for generator is works well, you can add `--path` options to use your local version

```
rb5 projectname --path=YOUR_LOCAL_GEM_PATH
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/5xRuby/rb5. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Rb5 project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/5xRuby/rb5/blob/master/CODE_OF_CONDUCT.md).
