# Cryptr

Cryptr is a minimal encryption module that follows the standard of SimpleBox or AES-256-CBC.

- SimpleBox: is recommended, and it handles multi_decrypyt gracefully.
- AES-256-CRC: A random iv is generated each time and prepended to the encrypted message.

## Installation

Install libsodium first.

```
# Linux/Ubuntu
apt-get install -y libsodium-dev

# Mac
brew install libsodium
```

Add this line to your application's Gemfile:

```ruby
gem 'cryptr'
```

## Usage

```ruby
require 'cryptr'

# Simplebox (recommended)

# hex string
SimpleboxCryptr.encrypt(key, data)
SimpleboxCryptr.decrypt(key, data)
# base64
SimpleboxCryptr.encrypt64(key, data)
SimpleboxCryptr.decrypt64(key, data)

# AES-256-CBC

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
