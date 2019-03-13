require "bindata"
require "hex_string"

require "ase_palette/version"
require "ase_palette/palette"
require "ase_palette/palette_binary"
require "ase_palette/group"
require "ase_palette/color"

module ASEPalette
  class Error < StandardError; end

  def self.new
    Palette.new
  end
end
