module ASEPalette
  DEFAULT_COLOR_TYPE = :global

  class Color
    # Name cannot changed once a color is created in order to
    # protect the integrity of unique names in a palette
    attr_reader :name
    attr_accessor :type

    # Get color model
    def model
      self.class.to_s.split('::').last.downcase.to_sym
    end

    # Convert color to string
    def to_s
      "#{@name}, " \
      "#{model.upcase}: " \
      "#{data.values.join("/")}, " \
      ":#{@type}"
    end

    # Convert color to hash,
    # necessary for binary representation
    def to_h
      {
        name: @name,
        model: model,
        data: data,
        type: @type,
      }
    end

    class RGB < Color
      attr_accessor :r, :g, :b
      def initialize(name, r, g, b, type = DEFAULT_COLOR_TYPE)
        @name = name
        @r = r
        @g = g
        @b = b
        @type = type
      end
      def data
        { r: @r, g: @g, b: @b }
      end
    end

    class CMYK < Color
      attr_accessor :c, :m, :y, :k
      def initialize(name, c, m, y, k, type = DEFAULT_COLOR_TYPE)
        @name = name
        @c = c
        @m = m
        @y = y
        @k = k
        @type = type
      end
      def data
        { c: @c, m: @m, y: @y, k: @k }
      end
    end

    class LAB < Color
      attr_accessor :l, :a, :b
      def initialize(name, l, a, b, type = DEFAULT_COLOR_TYPE)
        @name = name
        @l = l
        @a = a
        @b = b
        @type = type
      end
      def data
        { l: @l, a: @a, b: @b }
      end
    end

    class GRAY < Color
      attr_accessor :gray
      def initialize(name, gray, type = DEFAULT_COLOR_TYPE)
        @name = name
        @gray = gray
        @type = type
      end
      def data
        { gray: @gray }
      end
    end
  end
end
