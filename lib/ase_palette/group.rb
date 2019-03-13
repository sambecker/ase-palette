module ASEPalette
  class Group
    attr_reader :name, :colors

    def initialize(name)
      @name = name
      @colors = []
    end
  end
end