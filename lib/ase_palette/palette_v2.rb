module ASEPalette
  class PaletteV2

    # Constructor
    
    def initialize
      @version_major = 1
      @version_minor = 0
      @colors = []
      @groups = []
    end

    # Version

    def version
      "#{@version_major}.#{@version_minor}"
    end

    def set_version(major, minor)
      @version_major = major
      @version_minor = minor
    end

    # Accessors

    def colors
      @colors.clone
    end

    def get_color(name)
      all_colors = get_all_colors
      found_color = all_colors.select { |c| c.name == name }
      found_color.length >= 1 ? found_color[0] : nil
    end

    def groups
      @groups.clone
    end

    # Mutators

    def add_color(color)
      if color.is_a? Color
        if @colors.select { |c| c.name != color.name }.length == 0
          @colors << color
        else
          raise Error, "A color with that name already exists"
        end
      else
        raise Error, "Argument is not of type #{ASEPalette::Color}"
      end
    end

    def add_group(group)
      if group.is_a? Group
        if @groups.select { |g| g.name != group.name }.length == 0
          @groups << group
        else
          raise Error, "A group with that name already exists"
        end
      else
        raise Error, "Argument is not of type #{ASEPalette::Group}"
      end
    end

    private

    def get_all_colors
      colors_all = @colors
      # puts colors_all
      @groups.each { |group| colors_all += group.colors }
      # puts colors_all
      colors_all
    end
  end
end