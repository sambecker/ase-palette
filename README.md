# ASEPalette

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ase-palette'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ase-palette

## Usage

### Writing

```ruby
# Create palette
palette = ASEPalette.new

# Create color
color   = ASEPalette::Color::RGB.new "Red", 255, 0, 0

# Add color to palette
palette.add_color color

# Add color to group
palette.add_color color, group_name: "Group Name"
```

### Reading

```ruby
# Access top-level colors
palette.colors.each do |color|
  puts "Found color #{color.name}"
end

# Access colors from groups
palette.groups.each do |group|
  puts "Found group #{group.name}"
  group.colors.each do |color|
    puts "- #{color.name}"
  end
end

# Access all colors, including those from groups, as a flat array
palette.colors(include_from_groups: true).each do |color|
  puts "Found color #{color.name}, which may or may not belong to a group"
end
```

### Editing

```ruby
# Remove a color, including those from groups
palette.remove_color_with_name "Red"

# Remove a group and all of the colors it contains
palette.remove_group_with_name "Group Name" 
```

### Exporting

```ruby
# Store file
IO.binwrite('palette.ase', palette.to_binary)

# Send file (from Rails controller)
respond_to do |format|
  format.ase {
    send_data palette.to_binary, type: 'application/octet-stream', filename: 'palette.ase' 
  }
end
```

### Importing [UNDER DEVELOPMENT]

```ruby
# Open palette from file
palette = ASEPalette.open('path/to/palette.ase')

# Access color
puts palette.color_with_name "Red"
# Red, RGB: 255/0/0, :global

# Access palette
puts palette
# ASEPalette 2.0
# --------------
# 
# Red, RGB: 255/0/0, :global
#
# Group 1:
#   Violet, RGB: 90/0/255, :global
#   Blue, RGB: 0/0/255, :global
#   Green, RGB: 50/255/50, :global
#   Red, RGB: 240/0/20, :global
#
# Group 2
#   Orange CMYK, CMYK: 0/80/100/0, :global
#   Yellow CMYK, CMYK: 0/20/100/0, :global
#
# --------------
# 7 colors, 2 groups
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sambecker/ase-palette.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
