require "bindata"
require "hex_string"

require "ase-palette/version"
require "ase-palette/palette"
require "ase-palette/palette_binary"
require "ase-palette/group"
require "ase-palette/color"

module ASEPalette
  class Error < StandardError; end

  def self.new
    Palette.new
  end

  def self.open(path)
    Palette.new(path)
  end
end
