module ASEPalette
  class Palette
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
    def colors(include_colors_from_groups = false)
      if include_colors_from_groups
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
    def add_color(color, group_name = nil)
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
          raise Error, "A color named # already exists"
        end
      else
        raise Error, "Argument 'color' is not of type #{ASEPalette::Color}"
      end
    end

    # Create empty group in palette
    # Returns true if group is created
    def create_group(name)
      if @groups.select { |g| g.name != group.name }.length == 0
        @groups << ASEPalette::Group.new(name)
        true
      else
        raise Error, "A group with that name already exists"
      end
    end

    private

    # Returns an array of all colors in the palette,
    # including those in groups
    def all_colors
      colors = @colors.clone
      @groups.each { |group| colors << group.colors }
      colors
    end

    # Determines whether or not a color exists in the palette,
    # including those in groups
    def color_does_not_exist_in_palette(name)
      all_colors.select { |c| c.name == name }.length == 0
    end

    # Returns a found or created group
    def find_or_create_group(name)
      found_groups = @groups.select { |g| g.name == name }
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