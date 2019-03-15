# ASEPalette

[<img src="https://img.shields.io/gem/v/ase-palette.svg?color=g" />](https://rubygems.org/gems/ase-palette)
[<img src="https://img.shields.io/gem/dt/ase-palette.svg?color=g" />](https://rubygems.org/gems/ase-palette)

Create and manage Adobe ASE color palettes in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ase-palette'
```

## Usage

### 🚀 Load

```ruby
require 'ase-palette'
```

### 📝 Write

```ruby
# Create a palette
palette = ASEPalette.new

# Add a color
palette.add_color ASEPalette::Color::RGB.new "Red", 255, 0, 0

# Add a color to a group
palette.add_color ASEPalette::Color::CMYK.new "Yellow", 100, 0, 0, 0, group_name: "My Group"
```

### 📖 Read

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

### 🖋 Edit

```ruby
# Remove a color, including those from groups
palette.remove_color_with_name "Red"

# Remove a group and all of the colors it contains
palette.remove_group_with_name "Group Name" 
```

### ⬆️ Export

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

### ⬇️ Import

```ruby
# Open palette from file
palette = ASEPalette.open 'path/to/palette.ase'

# Access palette colors
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
