# Base32

Encode and decode with multiple Base32 alphabets.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     base32:
       github: lemarsu/base32
       version: 0.1.0
   ```

2. Run `shards install`

## Usage

```crystal
require "base32"

# Encode Base32 with RFC_4648
Base32.encode("Hello world") # => "JBSWY3DPEB3W64TMMQQQ===="

# Decode Base32 with RFC_4648
Base32.decode("JBSWY3DPEB3W64TMMQQQ====") # => "Hello world".to_slice

# Encode Base32 with Base32Hex
Base32.encode("Hello world", Base32::Hex) # => "91IMOR3F41RMUSJCCGGG===="

# Decode Base32 with Base32Hex
Base32.decode("91IMOR3F41RMUSJCCGGG====", Base32::Hex) # => "Hello world".to_slice

# Encode Base32 with Crockford
Base32.encode("Hello world", Base32::Crocford) # => "91JPRV3F41VPYWKCCGGG"

# Decode Base32 with Crockford
Base32.decode("91JPRV3F41VPYWKCCGGG", Base32::Crocford) # => "Hello world".to_slice
```

You can also configure your own and custom Base32 configuration

```crystal
custom_config = Base32::Config.new(
  "0123456789NJPQRSTUVWXYZABCDEFGHK",
  padding: false,
  charmap: {
    'I' => '1',
    'L' => '1',
    'O' => '0',
  }
)

Base32.encode("Hello world!", custom_config) # => "91VZBE3S41EZHFWPPTTT"

# The optional charmap is used for decoding
Base32.encode("91VZBE3S41EZHFWPPTTT", custom_config) # => "Hello world!".to_slice
Base32.encode("91vzbe3s41ezhfwppttt", custom_config) # => "Hello world!".to_slice
Base32.encode("9ivzbe3s41ezhfwppttt", custom_config) # => "Hello world!".to_slice
Base32.encode("9lvzbe3s41ezhfwppttt", custom_config) # => "Hello world!".to_slice
```

## Contributing

1. Fork it (<https://github.com/lemarsu/base32/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [LeMarsu](https://github.com/lemarsu) - creator and maintainer
