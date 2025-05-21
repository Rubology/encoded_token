## [2.0.0] - 2026-07-25

### Encoding Engine
EncodedToken can now encode any valid utf8 string. No longer limited to just integers and UUIDs. 

A new CRC8 checksum is included within the encoding to quickly detect any tampering or spoofing.

Any existing tokens are still decoded correctly, so no need to re-issue them.

### Configuration
Configuration has been expanded to allow setting default encoding values, along with adding multiple expiring ciphers. 
This allows for cipher rotation, without re-issuing unused tokens.

```
EncodedToken.configure do |config|
  config.seed = 555555
  config.cipher_count = 54
  config.max_input_size = 1000
  config.min_token_size = 100
  config.add_expiring_cipher(seed: 12345, cipher_count: 16, expiry_date: Date.new(2026, 6, 12))
  config.add_expiring_cipher(seed: 54321, cipher_count: 23, expiry_date: Date.new(2026, 8, 03))
end
```

**BREAKING CHANGE**

The default seed is no-longer set directly from the environment variable: `ENCODED_TOKEN_SEED`. 
Instead, set it within the configuration block:
```
EncodedToken.configure do |config|
  config.seed = ENV['ENCODED_TOKEN_SEED']
end
```

### Ruby Version

The minimum version is now Ruby 2.6 (was 2.5). While the gem still works in the 2.5 console, the test suite
is no-longer maintainable.


## [1.0.2] - 2022-10-04

- Initial release
