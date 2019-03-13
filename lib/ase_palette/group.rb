module ASEPalette
  class Group
    # TODO: prevent colors from being modified outside of Palette
    attr_reader :name, :colors

    def initialize(name)
      @name = name
      @colors = []
    end
  end
end