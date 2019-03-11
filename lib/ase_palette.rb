require "ase_palette/version"

module ASEPalette
  class Error < StandardError; end
  # Your code goes here...

  # Create
  palette = ASEPalette.new
  # Open
  palette = ASEPalette.open('File')

end
