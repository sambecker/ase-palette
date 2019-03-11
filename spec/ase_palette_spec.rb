require 'ase_palette_colors'

RSpec.describe ASEPalette do
  context "gem" do
    it "has a version number" do
      expect(ASEPalette::VERSION).not_to be nil
    end
  end

  context "palette" do
    before do
      @palette = ASEPalette.new
    end

    context "initializes" do
      it "with correct defaults" do
        expect(@palette.version).to     eq "1.0"
        expect(@palette.color_count).to eq 0
        expect(@palette.group_count).to eq 0
      end
    end

    context "sets" do
      it "version numbers" do
        @palette.set_version(2, 1)
        expect(@palette.version).to eq "2.1"
      end
    end
  
    context "adds" do
      it "color" do
        @palette.add_color(*COLOR_VIOLET_CMYK)
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 01 00 01 00 00 00 30 00 0c 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 35 c2 8f 3f 26 66 66 00 00 00 00 00 00 00 00 00 01"
      end
      it "lab color" do
        @palette.add_color(*COLOR_RED_LAB)
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 01 00 01 00 00 00 24 00 08 00 52 00 65 00 64 00 20 00 4c 00 41 00 42 00 00 4c 41 42 20 3f 05 1e b8 42 92 00 00 42 54 00 00 00 01"
      end
      it "grayscale color" do
        @palette.add_color(*COLOR_GRAY)
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 01 00 01 00 00 00 22 00 05 00 47 00 52 00 41 00 59 00 00 43 4d 59 4b 00 00 00 00 00 00 00 00 00 00 00 00 3f 26 66 66 00 01"
      end
      it "pantone color" do
        @palette.add_color(*COLOR_PANTONE_117_C)
        @palette.set_version(1, 0)
        expect(@palette.to_hex.upcase).to eq "41 53 45 46 00 01 00 00 00 00 00 01 00 01 00 00 00 30 00 0E 00 50 00 41 00 4E 00 54 00 4F 00 4E 00 45 00 20 00 31 00 31 00 37 00 20 00 43 00 00 4C 41 42 20 3F 29 A9 AA 41 40 00 00 42 9E 00 00 00 01"
      end
      it "multiple colors" do
        @palette.add_color(*COLOR_VIOLET_CMYK)
        @palette.add_color(*COLOR_VIOLET_RGB)
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 02 00 01 00 00 00 30 00 0c 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 35 c2 8f 3f 26 66 66 00 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2a 00 0b 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 52 00 47 00 42 00 00 52 47 42 20 3e 48 c8 c9 3e c8 c8 c9 3f 80 00 00 00 01"
      end
      it "group with colors" do
        group_name = "CMYK Colors"
        @palette.create_group(group_name)
        @palette.add_color_to_group(group_name, *COLOR_BLUE_CMYK)
        @palette.add_color_to_group(group_name, *COLOR_GREEN_CMYK)
        @palette.add_color_to_group(group_name, *COLOR_RED_CMYK)
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 05 c0 01 00 00 00 1a 00 0c 00 43 00 4d 00 59 00 4b 00 20 00 43 00 6f 00 6c 00 6f 00 72 00 73 00 00 00 01 00 00 00 2c 00 0a 00 42 00 6c 00 75 00 65 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 35 c2 8f 3d cc cc cd 00 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2e 00 0b 00 47 00 72 00 65 00 65 00 6e 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 80 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2a 00 09 00 52 00 65 00 64 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 00 00 00 00 3f 80 00 00 3f 80 00 00 00 00 00 00 00 01 c0 02 00 00 00 00"
      end
      it "multiple groups with colors" do
        group_name = "RGB Colors"
        @palette.create_group(group_name)
        @palette.add_color_to_group(group_name, *COLOR_VIOLET_RGB)
        @palette.add_color_to_group(group_name, *COLOR_BLUE_RGB)
        @palette.add_color_to_group(group_name, *COLOR_GREEN_RGB)
        @palette.add_color_to_group(group_name, *COLOR_RED_RGB)
  
        group_name = "CMYK Colors"
        @palette.create_group(group_name)
        @palette.add_color_to_group(group_name, *COLOR_VIOLET_CMYK)
        @palette.add_color_to_group(group_name, *COLOR_BLUE_CMYK)
        @palette.add_color_to_group(group_name, *COLOR_GREEN_CMYK)
        @palette.add_color_to_group(group_name, *COLOR_RED_CMYK)
  
        expect(@palette.to_hex).to eq "41 53 45 46 00 01 00 00 00 00 00 0c c0 01 00 00 00 18 00 0b 00 52 00 47 00 42 00 20 00 43 00 6f 00 6c 00 6f 00 72 00 73 00 00 00 01 00 00 00 2a 00 0b 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 52 00 47 00 42 00 00 52 47 42 20 3e 48 c8 c9 3e c8 c8 c9 3f 80 00 00 00 01 00 01 00 00 00 26 00 09 00 42 00 6c 00 75 00 65 00 20 00 52 00 47 00 42 00 00 52 47 42 20 00 00 00 00 00 00 00 00 3f 80 00 00 00 01 00 01 00 00 00 28 00 0a 00 47 00 72 00 65 00 65 00 6e 00 20 00 52 00 47 00 42 00 00 52 47 42 20 3e 48 c8 c9 3f 80 00 00 3e 48 c8 c9 00 01 00 01 00 00 00 24 00 08 00 52 00 65 00 64 00 20 00 52 00 47 00 42 00 00 52 47 42 20 3f 70 f0 f1 00 00 00 00 3d a0 a0 a1 00 01 c0 02 00 00 00 00 c0 01 00 00 00 1a 00 0c 00 43 00 4d 00 59 00 4b 00 20 00 43 00 6f 00 6c 00 6f 00 72 00 73 00 00 00 01 00 00 00 30 00 0c 00 56 00 69 00 6f 00 6c 00 65 00 74 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 35 c2 8f 3f 26 66 66 00 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2c 00 0a 00 42 00 6c 00 75 00 65 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 35 c2 8f 3d cc cc cd 00 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2e 00 0b 00 47 00 72 00 65 00 65 00 6e 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 3f 80 00 00 00 00 00 00 3f 00 00 00 00 00 00 00 00 01 00 01 00 00 00 2a 00 09 00 52 00 65 00 64 00 20 00 43 00 4d 00 59 00 4b 00 00 43 4d 59 4b 00 00 00 00 3f 80 00 00 3f 80 00 00 00 00 00 00 00 01 c0 02 00 00 00 00"
      end
    end
    
    context "removes" do
      it "colors" do
        expect(@palette.color_count).to eq 0
        @palette.add_color(*COLOR_VIOLET_CMYK)
        expect(@palette.color_count).to eq 1
        @palette.remove_color(COLOR_VIOLET_CMYK[0])
        expect(@palette.color_count).to eq 0
      end
      it "groups" do
        expect(@palette.group_count).to eq 0
        @palette.create_group("Group 1")
        @palette.create_group("Group 2")
        expect(@palette.group_count).to eq 2
        @palette.remove_group("Group 2")
        expect(@palette.group_count).to eq 1
      end
      it "colors from groups" do
        group_name = "Group 1"
        expect(@palette.color_count).to eq 0
        @palette.create_group(group_name)
        @palette.add_color_to_group(group_name, *COLOR_VIOLET_CMYK)
        @palette.add_color_to_group(group_name, *COLOR_RED_RGB)
        expect(@palette.color_count).to eq 2
        @palette.remove_color_from_group(group_name, COLOR_VIOLET_CMYK[0])
        expect(@palette.color_count).to eq 1
        @palette.remove_color_from_group(group_name, COLOR_RED_RGB[0])
        expect(@palette.color_count).to eq 0
      end
    end
  end
end