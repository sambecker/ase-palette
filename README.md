# ASEPalette

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ase_palette`. To experiment with that code, run `bin/console` for an interactive prompt.

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

### Importing `[UNDER DEVELOPMENT]`

```ruby
palette = ASEPalette.open('path/to/palette.ase')

palette.get_color("Red") # {name: "Red", model: :rgb data: {r: 255, g: 0, b: 0}}

puts palette
# ASEPalette 2.11
# ---------------
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
# ---------------
# 8 colors, 2 groups
```

## Legacy Usage (to be deleted)

### Create palette from scratch

```ruby
# Create palette
palette = ASEPalette.new
```

### Add individual colors
> Per Adobe's spec, colors must have unique names. If a color with a certain name already exists it will not be added.

```ruby
# Add colors
palatte.add_rgb_color  'RGB Color Name', 255, 0, 0
palatte.add_cmyk_color 'CMYK Color Name', 0, 100, 100, 0
palatte.add_lab_color  'LAB Color Name', 54, 81, 70
palatte.add_gray_color 'GRAY Color Name', 50
```

### Add grouped colors
> Per Adobe's spec, groups must have unique names. If a group with a certain name already exists it will not be added.

```ruby
# Create group
palette.create_group 'Group Name'

# Add colors
palette.add_rgb_color_to_group  'Group Name', 'RGB Color Name', 0, 100, 100, 0
palette.add_cmyk_color_to_group 'Group Name', 'CMYK Color Name', 0, 100, 100, 0
palette.add_lab_color_to_group  'Group Name', 'LAB Color Name', 54, 81, 70
palette.add_gray_color_to_group 'Group Name', 'GRAY Color Name', 50
```

### Plan B

```ruby
# Create palette
palette = ASEPalette.new

# Create group
group = ASEPalette::Group.new "My Group"

# Add color to group
group.add_color ASEPalette::Color::RGB.new("Red", 255, 0, 0, 0)

# Add palette to group
palette.add_group group
```

### Plan C

```ruby
# Create palette
palette = ASE::Palette.new

# Create group
group   = ASE::Group.new "My Group"

# Create color
color   = ASE::Color::RGB.new "Red", 255, 0, 0

# Add color to group
group.add_color color

# Add palette to group
palette.add_group group
```

### Plan D

```ruby
# Create palette
palette = ASEPalette.new
# or
palette = ASEPalette::Palette.new

# Create group
group   = ASEPalette::Group.new "My Group"

# Create color
color   = ASEPalette::Color::RGB.new "Red", 255, 0, 0

# Add color to group
group.add_color color

# Add palette to group
palette.add_group group
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sambecker/ase-palette.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
