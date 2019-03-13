module ASEPalette
  class PaletteV2

    # Palette constructor
    
    def initialize
      @version_major = 1
      @version_minor = 0
      @colors = []
      @groups = []
    end

    # Palette version

    def version
      "#{@version_major}.#{@version_minor}"
    end

    def set_version(major, minor)
      @version_major = major
      @version_minor = minor
    end

    # Color accessors

    def colors
      @colors.clone
    end

    def get_color_by_name(name)
      found_colors = get_all_colors.select { |c| c.name == name }
      found_colors.length >= 1 ? found_colors[0] : nil
    end

    # Group accessors

    def groups
      @groups.clone
    end

    def get_group_by_name(name)
      found_groups = @groups.select { |g| g.name == name }
      found_groups.length >= 1 ? found_groups[0] : nil
    end

    # Mutators

    def add_color(color, group_name = nil)
      if color.is_a? Color
        if color_does_not_exist_in_palette(color.name)
          if group_name
            group = find_or_create_group(group_name)
            group.colors << color
          else
            @colors << color
          end
        else
          raise Error, "A color with that name already exists"
        end
      else
        raise Error, "Argument is not of type #{ASEPalette::Color}"
      end
    end

    def create_group(name)
      if @groups.select { |g| g.name != group.name }.length == 0
        new_group = ASEPalette::Group.new(name)
        @groups << new_group
        new_group
      else
        raise Error, "A group with that name already exists"
      end
    end

    private

    def color_does_not_exist_in_palette(name)
      get_all_colors.select { |c| c.name == name }.length == 0
    end

    def get_all_colors
      colors_all = @colors
      # puts colors_all
      @groups.each { |group| colors_all += group.colors }
      # puts colors_all
      colors_all
    end

    def find_or_create_group(name)
      found_groups = @groups.select { |g| g.name == name }
      if found_groups.length > 0
        found_groups[0]
      else
        create_group(name)
      end
    end
  end
end