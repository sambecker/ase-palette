module ASEPalette
  require 'bindata'
  require "hex_string"

  require "ase_palette/version"
  require "ase_palette/palette"
  require "ase_palette/palette_binary"

  class Error < StandardError; end

# "
#   ase-palette > ASEPalette > ASEPalette:Palettr > ASEColor
# "

  def self.new
    color_rgb = Color::RGB.new("Blue", 0, 0, 255)
    group = Group.new("My Group")
    group.add_color([color_rgb])

    palette = ASEPalette.new
    palette.add_group(group)
    puts palette.groups.length

    Palette.new
  end
end

# Rename to doc?
module ASEPalette
  # Rename to Palette
  class ASEPalette
    attr_reader :colors, :groups
    
    def initialize
      @version_major = 1
      @version_minor = 0
      @colors = []
      @groups = []
    end

    def version
      "#{@version_major}.#{@version_minor}"
    end

    def set_version(major, minor)
      @version_major = major
      @version_minor = minor
    end

    def add_group(group)
      if group.is_a? Group
        if @groups.select { |g| g.name != group.name }.length == 0
          @groups.push(group)
        end
      end
    end
  end
  class Group
    attr_reader :name, :colors

    def initialize(name)
      @name = name
      @colors = []
    end
    def add_color(color)
      if color.is_a? Color
        if @colors.select { |c| c.name != color.name }
          @colors.push(color)
        end
      end      
    end
    def add_colors(colors)
      colors.each { |color| add_color(color) }
    end
  end
  class Color
    attr_reader :name, :model, :data, :type
    class RGB < Color
      def initialize(name, r, g, b, type = nil)
        @name = name
        @model = :rgb
        @data = { r: r, g: g, b: b }
        @type = type ? type : :global
      end
    end
  end
end
