require "hex_string"
require 'ase_palette/binary_service'

module ASEPalette
  DEFAULT_COLOR_TYPE = :global

  class Palette    
    # Constructor

    def initialize
      @version_major = 1
      @version_minor = 0
      @colors = []
      @groups = []
    end

    # Public methods

    def version
      "#{@version_major}.#{@version_minor}"
    end

    def set_version(major, minor)
      @version_major = major
      @version_minor = minor
    end

    def color_count
      color_count = 0
      color_count += @colors.length
      @groups.each do |group|
        color_count += group[:colors].length
      end
      color_count
    end

    def group_count
      @groups.length
    end

    # Group management

    def create_group(name)
      unless @groups.select { |group| group[:name] == name }.length > 0
        @groups.push({
          name: name,
          colors: []
        })
      end
    end

    def remove_group(name)
      @groups = @groups.select { |group| group[:name] != name }
    end 

    # Color management

    def add_rgb_color(name, r, g, b, type = DEFAULT_COLOR_TYPE)
      add_color(name, :rgb, { r: r, g: g, b: b }, type)
    end

    def add_cmyk_color(name, c, m, y, k, type = DEFAULT_COLOR_TYPE)
      add_color(name, :cmyk, { c: c, m: m, y: y, k: k }, type)
    end

    def add_lab_color(name, l, a, b, type = DEFAULT_COLOR_TYPE)
      add_color(name, :lab, { l: l, a: a, b: b }, type)
    end

    def add_gray_color(name, gray, type = DEFAULT_COLOR_TYPE)
      add_color(name, :gray, { gray: gray }, type)
    end

    def add_rgb_color_to_group(
      group_name, color_name, r, g, b, type = DEFAULT_COLOR_TYPE)
      add_color_to_group(
        group_name, color_name, :rgb, { r: r, g: g, b: b }, type)
    end

    def add_cmyk_color_to_group(
      group_name, color_name, c, m, y, k, type = DEFAULT_COLOR_TYPE)
      add_color_to_group(
        group_name, color_name, :cmyk, { c: c, m: m, y: y, k: k }, type)
    end

    def add_lab_color_to_group(
      group_name, color_name, l, a, b, type = DEFAULT_COLOR_TYPE)
      add_color_to_group(
        group_name, color_name, :lab, { l: l, a: a, b: b }, type)
    end

    def add_gray_color_to_group(
      group_name, color_name, gray, type = DEFAULT_COLOR_TYPE)
    add_color_to_group(
        group_name, color_name, :gray, { gray: gray }, type)
    end

    def remove_color(name)
      @colors = @colors.select { |color| color[:name] != name }
      @groups.each do |group|
        group[:colors] = group[:colors].select { |color| color[:name] != name }
      end
    end

    # Output

    def to_s
      s = "ASEPalette #{version}\n"
      divider = "#{"-" * (s.length - 1)}\n"
      s += divider
      @colors.each do |color|
        s += "#{color_to_s(color)}\n"
      end
      @groups.each do |group|
        s += "#{group[:name]}:\n"
        group[:colors].each do |color|
          s += "  #{color_to_s(color)}\n"
        end
      end
      s += divider
      s += "#{color_count} color#{if color_count != 0 then "s" end}\n"
      s += "#{group_count} group#{if color_count != 0 then "s" end}\n"
      s
    end

    def to_binary
      palette = BinaryService.build_binary_palette(
        @colors,
        @groups,
        @version_major,
        @version_minor,
      )
      palette.to_binary_s
    end

    def to_hex
      to_binary.to_hex_string
    end 

    private

    def color_to_s(color)
      "#{color[:name].encode(Encoding::UTF_8)}: " \
      "#{color[:data].map { |k, v| v }.join("/")}"
    end

    def add_color(name, model, data, type)
      unless @colors.select { |color| color[:name] == name }.length > 0
        @colors.push({
          name: name,
          model: model,
          data: data,
          type: type,
        })
      end
    end

    def add_color_to_group(group_name, color_name, model, data, type)
      found_groups = @groups.select { |group| group[:name] == group_name }
      if found_groups.length > 0
        group = found_groups[0]
        unless group[:colors].select { |color| color[:name] == color_name }.length > 0
          group[:colors].push({
            name: color_name,
            model: model,
            data: data,
            type: type,
          })
        end
      end
    end  

    def get_group(name)
      found_groups = @groups.select { |group| group[:name] == name }
      found_groups.length > 0 ? found_groups[0] : nil
    end

    def get_color_from_group(group_name, color_name)
      group = get_group(group_name)
      if group
        found_colors = group[:colors].select { |color| color[:name] == name }
        found_colors.length > 0 ? found_colors[0] : nil
      else
        nil
      end
    end
  end
end