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

    context "builds" do
      it "binary hash" do
        @palette.add_color ASEPalette::Color::CMYK.new "Cyan", 100, 0, 0, 0
        saved_color = @palette.color_with_name("Cyan")
        expect(saved_color.to_object).to eq({
          name: "Cyan",
          model: :cmyk,
          data: { c: 100, m: 0, y: 0, k: 0 },
          type: :global
        })
      end
    end
  end
end