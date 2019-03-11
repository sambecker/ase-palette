require "ase_palette/version"
require "ase_palette/palette"
require "ase_palette/binary_service"
require "hex_string"

module ASEPalette
  class Error < StandardError; end
  def self.new
    Palette.new
  end
  def self.open(path)
    # Call Palette.open() ...
  end
end
