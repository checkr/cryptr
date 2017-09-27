# Cryptr

Cryptr is a minimal encryption module that follows the standard of AES-256-CBC. A random iv is generated each time and prepended to the encrypted message.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cryptr'
```

## Usage

```ruby
require 'cryptr'

# hex string
Cryptr.encrypt(key, data)
Cryptr.decrypt(key, data)

# base64
Cryptr.encrypt64(key, data)
Cryptr.decrypt64(key, data)
```

## Development

```
rake test
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
