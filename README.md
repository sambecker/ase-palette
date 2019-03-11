# ASEBuilder

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ase_builder`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ase-builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ase-builder

## Usage

### Individual colors

```ruby
# Create palette
palette = ASEBuilder::Palette.new

# Add colors
palatte.add_rgb_color('RGB Color Name', 255, 0, 0)
palatte.add_cmyk_color('CMYK Color Name', 0, 100, 100, 0)
palatte.add_lab_color('LAB Color Name', 54, 81, 70)
palatte.add_gray_color('GRAY Color Name', 50)

# Output (from Rails)
send_data palette.to_binary, type: 'application/octet-stream', filename: 'palette.ase'
```

### Grouped colors

```ruby
# Create palette
palette = ASEBuilder::Palette.new

# Create group
palette.create_group('Group Name')

# Add colors
palette.add_rgb_color_to_group('Group Name', 'RGB Color Name', 0, 100, 100, 0)
palette.add_cmyk_color_to_group('Group Name', 'CMYK Color Name', 0, 100, 100, 0)
palette.add_lab_color_to_group('Group Name', 'LAB Color Name', 54, 81, 70)
palette.add_gray_color_to_group('Group Name', 'GRAY Color Name', 50)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sambecker/ase-builder.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
