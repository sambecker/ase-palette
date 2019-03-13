module ASEPalette
  class Palette
    # TODO: Consider removing 'with_name' from method signatures
    # TODO: Make sure to encode strings back to UTF-8 when importing ASE files
 
    # Initialize palette
    def initialize
      @version_major = 1
      @version_minor = 0
      @colors = []
      @groups = []
    end

    # Get palette version
    def version
      "#{@version_major}.#{@version_minor}"
    end

    # Set palette version
    def set_version(major, minor)
      @version_major = major
      @version_minor = minor
    end

    # Get read-only list of colors
    # Optionally include all colors from groups
    def colors(include_from_groups: false)
      if include_from_groups
        all_colors
      else
        @colors.clone
      end
    end

    # Get color by name
    def color_with_name(name)
      found_colors = all_colors.select { |c| c.name == name }
      found_colors.length >= 1 ? found_colors[0] : nil
    end

    # Get read-only list of groups
    def groups
      @groups.clone
    end

    # Get read-only group by name
    def group_with_name(name)
      found_groups = @groups.select { |g| g.name == name }
      found_groups.length >= 1 ? found_groups[0].clone : nil
    end

    # Add color to palette
    # Optionally provide 'group_name' to place color in group
    # Group will be created if it does not exist
    # Returns true if color is added
    def add_color(color, group_name: nil)
      if color.is_a? Color
        if color_does_not_exist_in_palette(color.name)
          if group_name
            group = find_or_create_group(group_name)
            group.colors << color
            true
          else
            @colors << color
            true
          end
        else
          raise Error, "A color named #{color.name} already exists"
        end
      else
        raise Error, "Argument 'color' is not of type #{ASEPalette::Color}"
      end
    end

    # Create empty group in palette
    # Returns true if group is created
    def create_group(name)
      if @groups.select { |group| group.name == name }.length == 0
        @groups << ASEPalette::Group.new(name)
        true
      else
        raise Error, "A group named #{name} already exists"
      end
    end

    # Remove color from palette
    # Color may or may not be in a group
    def remove_color_with_name(name)
      @colors = @colors.select { |color| color.name != name }
      @groups.each { |group| group.remove_color_with_name(name) }
      true
    end

    # Remove group, and its colors, from palette
    def remove_group_with_name(name)
      @groups = @groups.select { |group| group.name != name }
      true
    end

    # Create string representation of palette
    def to_s
      s = "ASEPalette #{version}\n"
      divider = "#{"-" * (s.length - 1)}\n"
      s += divider
      if @colors.length > 0 || @groups.length > 0
        s += "\n"
        @colors.each do |color|
          s += "#{color}\n"
        end
        s += "\n"
        @groups.each do |group|
          s += "#{group}\n"
        end
      else
        s += "This palette is empty\n"
      end
      s += divider
      s += "#{all_colors.length} color#{if all_colors.length != 1 then "s" end}, " \
           "#{@groups.length} group#{if @groups.length != 1 then "s" end}"
      s
    end

    # Create binary representation of palette
    def to_binary
      palette = PaletteBinary.build_binary_palette(
        @colors.map(&:to_h),
        @groups.map(&:to_h),
        @version_major,
        @version_minor,
      )
      palette.to_binary_s
    end

    # Create human-readable hex representation of palette
    def to_hex
      to_binary.to_hex_string
    end 

    private

    # Returns an array of all colors in the palette,
    # including those in groups
    def all_colors
      @colors + @groups.map { |group| group.colors }.flatten
    end

    # Determines whether or not a color exists in the palette,
    # including those in groups
    def color_does_not_exist_in_palette(name)
      all_colors.select { |color| color.name == name }.length == 0
    end

    # Returns a found or created group
    def find_or_create_group(name)
      found_groups = @groups.select { |group| group.name == name }
      if found_groups.length > 0
        found_groups[0]
      else
        new_group = ASEPalette::Group.new(name)
        @groups << new_group
        new_group
      end
    end
  end
end