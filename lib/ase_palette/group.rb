module ASEPalette
  class Group
    attr_reader :name, :colors

    def initialize(name)
      @name = name
      @colors = []
    end

    def add_color(color)
      if color.is_a? Color
        if @colors.select { |c| c.name != color.name }
          @colors << color
        else
          raise Error, "A color with that name already exists"
        end
      else
        raise Error, "Argument is not of type #{ASEPalette::Color}"
      end
    end

    def add_colors(colors)
      colors.each { |color| add_color(color) }
    end
  end
end