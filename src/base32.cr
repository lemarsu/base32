require "./base32/config.cr"

module Base32
  VERSION = "0.1.1"
  class Error < Exception; end

  RFC_4648 = Config.new(
    alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567",
    padding: '=',
    charmap: {
      '0' => 'O',
      '1' => 'I'
    }
  )

  Crockford = Config.new(
    "0123456789ABCDEFGHJKMNPQRSTVWXYZ",
    charmap: {
      'O' => '0',
      'I' => '1',
      'L' => '1'
    }
  )

  Hex = Config.new(
    "0123456789ABCDEFGHIJKLMNOPQRSTUV",
    padding: '=',
    charmap: {} of Char => Char
  )

  extend self

  def encode(buffer : String, config = RFC_4648) : String
    encode(buffer.to_slice, config)
  end

  def encode(buffer : Bytes, config = RFC_4648) : String
    str = String.build do |io|
      each_5_bits(buffer) do |symbol|
        io << config.alphabet[symbol]
      end
    end
    return str if str.size % 8 == 0 || !config.padding?
    str + config.padding.to_s * (8 - str.size % 8)
  end

  def decode(buffer : String, config = RFC_4648) : Bytes
    shift = 8i32
    carry = 0u8
    io = IO::Memory.new
    buffer.upcase.each_char do |char|
      next if config.padding? && char == config.padding
      symbol = config.charmap[char] & 0xFF

      shift -= 5;

      if shift > 0
        carry |= symbol << shift
      elsif shift < 0
        io.write_byte (carry | (symbol >> -shift)).to_u8
        shift += 8
        carry = (symbol << shift) & 0xFF
      else
        io.write_byte (carry | symbol).to_u8
        shift = 8
        carry = 0
      end
    end
    io.to_slice

  rescue ex : KeyError
    raise Error.new("Unknown char '#{ex.message.not_nil![-2]}'")
  end

  # 1: 00000 000
  # 2:          00 00000 0
  # 3:                    0000 0000
  # 4:                             0 00000 00
  # 5:                                       000 00000

  private def each_5_bits(bytes : Bytes, & : UInt8 -> Void) : Void
    shift = 3
    carry = 0u8
    bytes.each do |byte|
      symbol = carry | (byte >> shift)
      yield symbol & 0x1Fu8

      if shift > 5
        shift -= 5
        symbol = byte >> shift;
        yield symbol & 0x1Fu8
      end

      shift = 5 - shift
      carry = byte << shift
      shift = 8 - shift;
    end

    if shift != 3
      yield carry & 0x1Fu8
    end
  end
end
