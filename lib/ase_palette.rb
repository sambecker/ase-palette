require 'bindata'
require "hex_string"

require_relative "ase_palette/version"
require_relative "ase_palette/palette"
require_relative "ase_palette/palette_v2"
require_relative "ase_palette/palette_binary"
require_relative "ase_palette/group"
require_relative "ase_palette/color"

module ASEPalette
  class Error < StandardError; end

  def self.new
    Palette.new
  end
end
