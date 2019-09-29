module Base32
  class Config
    getter alphabet : String
    getter charmap : Hash(Char, UInt8)
    getter padding : Bool

    def initialize(@alphabet, *, @padding, charmap : Hash(Char, Char)?)
      @charmap = {} of Char => UInt8
      @alphabet.each_char.each_with_index do |char, idx|
        @charmap[char] = idx.to_u8
      end
      charmap.each do |key, value|
        @charmap[key] = @charmap[value]
      end
    end
  end
end
