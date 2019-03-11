include ASEBuilder

module PaletteService
  class << self
    def generate_ase_palette_from_color(color)
      palette = ASEBuilder::Palette.new

      palette.add_rgb_color(
        "#{color.name} RGB", *color.rgb(true))
      palette.add_cmyk_color(
        "#{color.name} CMYK", *color.cmyk(true))
      palette.add_lab_color(
        "PANTONE #{color.pantone.name}", *color.pantone.lab(true), :spot)
      
      palette
    end
    def generate_ase_palette_from_colors(name, colors)
      palette = ASEBuilder::Palette.new
  
      group_name_rgb = "#{name} RGB"
      group_name_cmyk = "#{name} CMYK"
      group_name_pantone = "#{name} PANTONE"
  
      palette.create_group(group_name_rgb)
      palette.create_group(group_name_cmyk)
      palette.create_group(group_name_pantone)
  
      colors.each do |color|
        palette.add_rgb_color_to_group(group_name_rgb,
          "#{color.name} RGB", *color.rgb(true))
        palette.add_cmyk_color_to_group(group_name_cmyk,
          "#{color.name} CMYK", *color.cmyk(true))
        if color.pantone
          palette.add_lab_color_to_group(group_name_pantone,
            "PANTONE #{color.pantone.name}", *color.pantone.lab(true), :spot)
        end
      end

      palette
    end
  end
end