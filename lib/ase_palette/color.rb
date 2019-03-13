module ASEPalette
  DEFAULT_COLOR_TYPE = :global

  class Color
    attr_reader :name, :model, :type

    def to_s
      "#{@name}, " \
      "#{@model.upcase}: " \
      "#{data.values.join("/")}, " \
      ":#{@type}"
    end

    def to_object
      {
        name: @name,
        model: @model,
        data: data,
        type: @type,
      }
    end

    class RGB < Color
      attr_reader :r, :g, :b
      def initialize(name, r, g, b, type = DEFAULT_COLOR_TYPE)
        @name = name
        @model = :rgb
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
      attr_reader :c, :m, :y, :k
      def initialize(name, c, m, y, k, type = DEFAULT_COLOR_TYPE)
        @name = name
        @model = :cmyk
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
      attr_reader :l, :a, :b
      def initialize(name, l, a, b, type = DEFAULT_COLOR_TYPE)
        @name = name
        @model = :lab
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
      attr_reader :gray
      def initialize(name, gray, type = DEFAULT_COLOR_TYPE)
        @name = name
        @model = :gray
        @gray = gray
        @type = type
      end
      def data
        { gray: @gray }
      end
    end
  end
end
