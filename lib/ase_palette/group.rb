module ASEPalette
  class Group
    # Name and colors cannot changed once a group is created in order to
    # protect the integrity of unique names in a palette
    attr_reader :name, :colors
    
    # Initialize group
    def initialize(name)
      @name = name
      @colors = []
    end

    # Convert group to string
    def to_s
      s = "- #{@name}:\n"
      if @colors.length > 0
        @colors.each do |color|
          s += "  #{color}\n"
        end
      else
        s += "  <empty>\n"
      end
      s
    end

    # Convert group to hash,
    # necessary for binary representation
    def to_h
      {
        name: @name,
        colors: @colors.map(&:to_h),
      }
    end

    def remove_color_with_name(name)
      @colors = @colors.select { |color| color.name != name }
    end
  end
end