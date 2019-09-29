module Base32
  class Config
    getter alphabet : String
    getter charmap : Hash(Char, Char)
    getter padding : Bool

    def initialize(@alphabet, *, @padding, charmap : Hash(Char, Char)?)
      @charmap = {} of Char => Char
    end
  end
end
