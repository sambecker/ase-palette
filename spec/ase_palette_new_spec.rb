RSpec.describe ASEPalette do
  context "gem" do
    it "has a version number" do
      expect(ASEPalette::VERSION).not_to be nil
    end
  end

  context "palette" do
    before do
      @palette = ASEPalette::PaletteV2.new
    end

    context "initializes" do
      it "with correct defaults" do
        expect(@palette.version).to     eq "1.0"
        expect(@palette.colors.length).to eq 0
        expect(@palette.groups.length).to eq 0
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
        saved_color = @palette.get_color_by_name("Red")
        expect(saved_color.data).to eq({ r: 255, g: 0, b: 0 })
      end
      it "cmyk color" do
        @palette.add_color ASEPalette::Color::CMYK.new "Cyan", 100, 0, 0, 0
        saved_color = @palette.get_color_by_name("Cyan")
        expect(saved_color.data).to eq({ c: 100, m: 0, y: 0, k: 0 })
      end
      it "color to group" do
        color = ASEPalette::Color::RGB.new "Red", 255, 0, 0
        expect(@palette.colors.length).to eq 0
        expect(@palette.groups.length).to eq 0
        @palette.add_color color, "New Group"
        expect(@palette.colors.length).to eq 0
        expect(@palette.groups.length).to eq 1
      end
    end

    context "builds" do
      it "binary hash" do
        @palette.add_color ASEPalette::Color::CMYK.new "Cyan", 100, 0, 0, 0
        saved_color = @palette.get_color_by_name("Cyan")
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