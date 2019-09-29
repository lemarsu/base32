module Base32
  VERSION = "0.0.1"
  class Error < Exception; end

  private CHARS = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

  extend self

  def encode(buffer : String) : String
    encode(buffer.to_slice)
  end

  def encode(buffer : Slice) : String
    String.build do |io|
      each_5_bits(buffer) do |symbol|
        io << CHARS[symbol]
      end
    end
  end

  def decode(buffer : String) : Bytes
    shift = 8i32
    carry = 0u8
    array = [] of UInt8
    buffer.to_slice.each do |byte|
      next if byte == '='
      symbol = CHARS.byte_index(byte).not_nil! & 0xFF

      shift -= 5;

      if shift > 0
        carry |= symbol << shift
      elsif shift < 0
        array << (carry | (symbol >> -shift)).to_u8
        shift += 8
        carry = (symbol << shift) & 0xFF
      else
        array << (carry | symbol).to_u8
        shift = 8
        carry = 0
      end
    end
    Slice(UInt8).new(array.to_unsafe, array.size)
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
