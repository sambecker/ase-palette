RSpec.describe ASEPalette do
  context "gem" do
    it "has a version number" do
      expect(ASEPalette::VERSION).not_to be nil
    end
  end

  context "palette opened from file" do
    before do
      @palette = ASEPalette.open "spec/palette_complex.ase"
    end

    it "has correct shape" do
      expect(@palette.version).to                                   eq "1.0"
      expect(@palette.colors.length).to                             eq 0
      expect(@palette.colors(include_from_groups: true).length).to  eq 21
      expect(@palette.groups.length).to                             eq 3
    end
  end

  context "new palette" do
    before do
      @palette = ASEPalette.new
    end

    context "initializes" do
      it "with correct defaults" do
        expect(@palette.version).to             eq "1.0"
        expect(@palette.colors.length).to       eq 0
        expect(@palette.colors(include_from_groups: true).length).to eq 0
        expect(@palette.groups.length).to       eq 0
      end
    end

    context "sets" do
      it "version numbers" do
        @palette.set_version(2, 1)
        expect(@palette.version).to eq "2.1"
      end
    end

    context "adds" do
      it "rgb color" do
        @palette.add_color ASEPalette::Color::RGB.new "Red", 255, 0, 0
        saved_color = @palette.color_with_name("Red")
        expect(saved_color.data).to eq({ r: 255, g: 0, b: 0 })
      end
      it "cmyk color" do
        @palette.add_color ASEPalette::Color::CMYK.new "Cyan", 100, 0, 0, 0
        saved_color = @palette.color_with_name("Cyan")
        expect(saved_color.data).to eq({ c: 100, m: 0, y: 0, k: 0 })
      end
      it "color to group" do
        color = ASEPalette::Color::RGB.new "Red", 255, 0, 0
        expect(@palette.colors.length).to       eq 0
        expect(@palette.groups.length).to       eq 0
        @palette.add_color color, group_name: "New Group"
        expect(@palette.colors.length).to       eq 0
        expect(@palette.colors(include_from_groups: true).length).to eq 1
        expect(@palette.groups.length).to       eq 1
      end
      it "multiple colors" do
        color_1 = ASEPalette::Color::RGB.new "Red RGB", 255, 0, 0
        color_2 = ASEPalette::Color::CMYK.new "Red CMYK", 0, 100, 100, 0
        @palette.add_colors [color_1, color_2]
        expect(@palette.colors.length).to eq 2
      end
      it "multiple colors to group" do
        color_1 = ASEPalette::Color::RGB.new "Red RGB", 255, 0, 0
        color_2 = ASEPalette::Color::CMYK.new "Red CMYK", 0, 100, 100, 0
        @palette.add_colors [color_1, color_2], group_name: "Group"
        expect(@palette.groups.length).to                           eq 1
        expect(@palette.group_with_name("Group").colors.length).to  eq 2
      end
    end

    context "removes" do
      before do
        @palette.add_color ASEPalette::Color::RGB.new *COLOR_VIOLET_RGB
        @palette.add_color ASEPalette::Color::CMYK.new *COLOR_VIOLET_CMYK
        @palette.create_group("First group")
        @palette.add_color ASEPalette::Color::LAB.new(*COLOR_RED_LAB),
          group_name: "First group"
        @palette.create_group("Second group")
        @palette.add_color ASEPalette::Color::CMYK.new(*COLOR_CYAN_CMYK),
          group_name: "Second group"
      end
      it "color" do
        expect(@palette.colors.length).to eq 2
        @palette.remove_color_with_name(COLOR_VIOLET_RGB[0])
        expect(@palette.colors.length).to eq 1
      end
      it "color from group" do
        expect(@palette.colors(include_from_groups: true).length).to eq 4
        @palette.remove_color_with_name(COLOR_RED_LAB[0])
        expect(@palette.colors(include_from_groups: true).length).to eq 3        
      end
      it "group" do
        expect(@palette.colors(include_from_groups: true).length).to eq 4
        expect(@palette.groups.length).to eq 2
        @palette.remove_group_with_name("First group")
        expect(@palette.colors(include_from_groups: true).length).to eq 3
        expect(@palette.groups.length).to eq 1
      end
    end

    context "prints" do
      it "palette information" do
        @palette.set_version(2, 0)
        @palette.add_color(
          ASEPalette::Color::RGB.new("First color", 255, 100, 50))
        
        group_name = "First group"
        @palette.add_color(
          ASEPalette::Color::RGB.new("Second color", 10, 200, 20),
          group_name: group_name)
        @palette.add_color(
          ASEPalette::Color::CMYK.new("Third color", 100, 0, 0, 0, :normal),
          group_name: group_name)

        group_name = "Second group"
        @palette.add_color(
          ASEPalette::Color::LAB.new("Fourth color", 100, 50, 4, :spot),
          group_name: group_name)
        @palette.add_color(
          ASEPalette::Color::GRAY.new("Fifth color", 55),
          group_name: group_name)

        expect(@palette.to_s).to eq(
          "ASEPalette 2.0\n"\
          "--------------\n"\
          "\n"\
          "First color, RGB: 255/100/50, :global\n"\
          "\n"\
          "- First group:\n"\
          "  Second color, RGB: 10/200/20, :global\n"\
          "  Third color, CMYK: 100/0/0/0, :normal\n"\
          "\n"\
          "- Second group:\n"\
          "  Fourth color, LAB: 100/50/4, :spot\n"\
          "  Fifth color, GRAY: 55, :global\n"\
          "\n"\
          "--------------\n"\
          "5 colors, 2 groups"
        )
      end
    end

    context "builds binary" do
      it "hash" do
        @palette.add_color ASEPalette::Color::CMYK.new "Cyan", 100, 0, 0, 0
        saved_color = @palette.color_with_name("Cyan")
        expect(saved_color.to_h).to eq({
          name: "Cyan",
          model: :cmyk,
          data: { c: 100, m: 0, y: 0, k: 0 },
          type: :global
        })
      end
      it "rgb color" do
        @palette.add_color ASEPalette::Color::RGB.new *COLOR_VIOLET_RGB
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 01 00 01 00 00 00 2a 00 0b 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 52 00 47 00 42 00 00 52 47 42 20 3e 50 d0 d1 3e c8 c8 c9 3f 80 00 00 00 01"
      end
      it "cmyk color" do
        @palette.add_color ASEPalette::Color::CMYK.new *COLOR_VIOLET_CMYK
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 01 00 01 00 00 00 30 00 0c 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 35 c2 8f 3f 05 1e b8 00 00 00 00 00 00 00 00 00 01"
      end
      it "lab color" do
        @palette.add_color ASEPalette::Color::LAB.new *COLOR_RED_LAB
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 01 00 01 00 00 00 24 00 08 00 52 00 65 00 64 00 20 00 4c 00 41 00 42 00 00 4c 41 42 20 3f 05 1e b8 42 92 00 00 42 54 00 00 00 01"
      end
      it "grayscale color" do
        @palette.add_color ASEPalette::Color::GRAY.new *COLOR_GRAY
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 01 00 01 00 00 00 22 00 05 00 47 00 52 00 41 00 59 00 00 43 4d 59 4b 00 00 00 00 00 00 00 00 00 00 00 00 3f 26 66 66 00 01"
      end
      it "pantone color" do
        @palette.add_color ASEPalette::Color::LAB.new *COLOR_PANTONE_117_C
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 01 00 01 00 00 00 30 00 0e 00 50 00 41 00 4e 00 54 00 4f 00 4e 00 45 00 20 00 31 00 31 00 37 00 20 00 43 00 00 4c 41 42 20 3f 28 f5 c3 41 40 00 00 42 9e 00 00 00 01"
      end
      it "set of colors" do
        @palette.add_color ASEPalette::Color::CMYK.new *COLOR_VIOLET_CMYK
        @palette.add_color ASEPalette::Color::RGB.new *COLOR_VIOLET_RGB
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 02 00 01 00 00 00 30 00 0c 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 35 c2 8f 3f 05 1e b8 00 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2a 00 0b 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 52 00 47 00 42 00 00 52 47 42 20 3e 50 d0 d1 3e c8 c8 c9 3f 80 00 00 00 01"
      end
      it "group with colors" do
        group_name = "CMYK Colors"
        @palette.add_color ASEPalette::Color::CMYK.new(*COLOR_BLUE_CMYK),
          group_name: group_name
        @palette.add_color ASEPalette::Color::CMYK.new(*COLOR_GREEN_CMYK),
          group_name: group_name
        @palette.add_color ASEPalette::Color::CMYK.new(*COLOR_RED_CMYK),
          group_name: group_name
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 05 c0 01 00 00 00 1a 00 0c 00 43 00 4d 00 59 00 4b 00 20 00 43 00 6f 00 6c 00 6f 00 72 00 73 00 00 00 01 00 00 00 2c 00 0a 00 42 00 6c 00 75 00 65 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 35 c2 8f 3d cc cc cd 00 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2e 00 0b 00 47 00 72 00 65 00 65 00 6e 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 80 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2a 00 09 00 52 00 65 00 64 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 00 00 00 00 3f 80 00 00 3f 80 00 00 00 00 00 00 00 01 c0 02 00 00 00 00"
      end
      it "set of groups with colors" do
        group_name = "RGB Colors"
        @palette.add_color ASEPalette::Color::RGB.new(*COLOR_VIOLET_RGB),
          group_name: group_name
        @palette.add_color ASEPalette::Color::RGB.new(*COLOR_BLUE_RGB),
          group_name: group_name
        @palette.add_color ASEPalette::Color::RGB.new(*COLOR_GREEN_RGB),
          group_name: group_name
        @palette.add_color ASEPalette::Color::RGB.new(*COLOR_RED_RGB),
          group_name: group_name
  
        group_name = "CMYK Colors"
        @palette.add_color ASEPalette::Color::CMYK.new(*COLOR_VIOLET_CMYK),
          group_name: group_name
        @palette.add_color ASEPalette::Color::CMYK.new(*COLOR_BLUE_CMYK),
          group_name: group_name
        @palette.add_color ASEPalette::Color::CMYK.new(*COLOR_GREEN_CMYK),
          group_name: group_name
        @palette.add_color ASEPalette::Color::CMYK.new(*COLOR_RED_CMYK),
          group_name: group_name
  
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 0c c0 01 00 00 00 18 00 0b 00 52 00 47 00 42 00 20 00 43 00 6f 00 6c 00 6f 00 72 00 73 00 00 00 01 00 00 00 2a 00 0b 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 52 00 47 00 42 00 00 52 47 42 20 3e 50 d0 d1 3e c8 c8 c9 3f 80 00 00 00 01 00 01 00 00 00 26 00 09 00 42 00 6c 00 75 00 65 00 20 00 52 00 47 00 42 00 00 52 47 42 20 00 00 00 00 00 00 00 00 3f 80 00 00 00 01 00 01 00 00 00 28 00 0a 00 47 00 72 00 65 00 65 00 6e 00 20 00 52 00 47 00 42 00 00 52 47 42 20 3e 48 c8 c9 3f 80 00 00 3e 50 d0 d1 00 01 00 01 00 00 00 24 00 08 00 52 00 65 00 64 00 20 00 52 00 47 00 42 00 00 52 47 42 20 3f 70 f0 f1 00 00 00 00 3d a0 a0 a1 00 01 c0 02 00 00 00 00 c0 01 00 00 00 1a 00 0c 00 43 00 4d 00 59 00 4b 00 20 00 43 00 6f 00 6c 00 6f 00 72 00 73 00 00 00 01 00 00 00 30 00 0c 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 35 c2 8f 3f 05 1e b8 00 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2c 00 0a 00 42 00 6c 00 75 00 65 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 35 c2 8f 3d cc cc cd 00 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2e 00 0b 00 47 00 72 00 65 00 65 00 6e 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 80 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2a 00 09 00 52 00 65 00 64 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 00 00 00 00 3f 80 00 00 3f 80 00 00 00 00 00 00 00 01 c0 02 00 00 00 00"
      end
    end
  end

  context "write and read the same file with" do
    # Setup palettes
    palette = ASEPalette.new
    palette_from_file = nil

    # Create color data
    color_1 = ASEPalette::Color::CMYK.new(*COLOR_VIOLET_CMYK)
    color_2 = ASEPalette::Color::RGB.new(*COLOR_RED_RGB)
    group_1 = "Group 1"
    color_3 = ASEPalette::Color::CMYK.new(*COLOR_CYAN_CMYK)
    color_4 = ASEPalette::Color::CMYK.new(*COLOR_BLUE_CMYK)
    group_2 = "Group 2"
    color_5 = ASEPalette::Color::RGB.new(*COLOR_GREEN_RGB)
    color_6 = ASEPalette::Color::RGB.new(*COLOR_VIOLET_RGB)
    group_3 = "Group 3"
    color_7 = ASEPalette::Color::LAB.new(*COLOR_RED_LAB)
    color_8 = ASEPalette::Color::LAB.new(*COLOR_PANTONE_117_C)

    # Build palette
    palette.add_color color_1
    palette.add_color color_2
    palette.add_color color_3, group_name: group_1
    palette.add_color color_4, group_name: group_1
    palette.add_color color_5, group_name: group_2
    palette.add_color color_6, group_name: group_2
    palette.add_color color_7, group_name: group_3
    palette.add_color color_8, group_name: group_3

    # Set file path
    palette_file_path = "spec/temp_palatte.ase"

    # Save palette
    IO.binwrite(palette_file_path, palette.to_binary)

    # Import palette
    palette_from_file = ASEPalette.open palette_file_path      

    # Delete temporary file
    File.delete palette_file_path

    context "with matching" do
      it "data" do
        palette.colors(include_from_groups: true).each_with_index do |color, index|
          expect(color.data).to eq(
            palette_from_file.colors(include_from_groups: true)[index].data)
        end
      end

      it "shapes" do
        expect(palette_from_file.colors.length).to(
          eq palette.colors.length)
        expect(palette_from_file.colors(include_from_groups: true).length).to(
          eq palette.colors(include_from_groups: true).length)
        expect(palette_from_file.groups.length).to(
          eq palette.groups.length)
      end
  
      it "string representations" do
        expect(palette_from_file.to_s).to eq palette.to_s
      end
  
      it "binary representations" do
        expect(palette_from_file.to_hex).to eq palette.to_hex
      end
    end
  end
end