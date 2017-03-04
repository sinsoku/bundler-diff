# BundlerDiffgems

[![Gem Version](https://badge.fury.io/rb/bundler_diffgems.svg)](https://badge.fury.io/rb/bundler_diffgems)
[![Build Status](https://travis-ci.org/sinsoku/bundler_diffgems.svg?branch=master)](https://travis-ci.org/sinsoku/bundler_diffgems)
[![codecov](https://codecov.io/gh/sinsoku/bundler_diffgems/branch/master/graph/badge.svg)](https://codecov.io/gh/sinsoku/bundler_diffgems)

A bundler subcommand that uses Git, compare with the previous Gemfile.lock, and display updated gems and compare links.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bundler_diffgems'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bundler_diffgems

## Usage

Run `bundle update` as usual:

```
$ bundle update
Fetching gem metadata from https://rubygems.org
...
```

Then `bundle diffgems`:

```
$ bundle diffgems
rake: 11.3.0 => 12.0.0 - https://github.com/ruby/rake/compare/v11.3.0...v12.0.0
rspec: 3.5.0 =>
...
```

You can see updated gems with compare links.

## Options

Options are:

```
Usage: bundle diffgems [options]
    -c, --commit COMMIT              Specify a commit
    -f, --format FORMATTER           Choose a formatter
                                       default
                                       md_table
        --escape-json                Escape output as a JSON string
    -v, --version                    Display the version
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sinsoku/bundler_diffgems. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

