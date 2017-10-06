require 'base64'
require 'openssl'
require 'rbnacl/libsodium'
require 'rbnacl'
require 'securerandom'

require 'cryptr/version'

# Cryptr is a minimal encryption module that follows the standard of AES-256-CBC
# A random iv is generated each time and prepended to the encrypted message
module Cryptr
  ENCRYPTION_METHOD = 'aes-256-cbc'.freeze
  IV_LENGTH = 16

  # encrypts data with the given key. returns a binary data with the
  # unhashed random iv in the first 16 bytes
  def self.encrypt(key, data)
    cipher = OpenSSL::Cipher.new(ENCRYPTION_METHOD)
    cipher.encrypt
    cipher.key = key = OpenSSL::Digest::SHA256.digest(key)
    random_iv = cipher.random_iv
    cipher.iv = OpenSSL::Digest::SHA256.digest(random_iv + key)[0...IV_LENGTH]
    encrypted = cipher.update(data)
    encrypted << cipher.final
    random_iv + encrypted
  end

  def self.decrypt(key, data) # rubocop:disable Metrics/MethodLength
    cipher = OpenSSL::Cipher.new(ENCRYPTION_METHOD)
    cipher.decrypt
    cipher.key = cipher_key = OpenSSL::Digest::SHA256.digest(key)
    random_iv = data[0...IV_LENGTH]
    data = data[IV_LENGTH..-1]
    digest = OpenSSL::Digest::SHA256.digest(random_iv + cipher_key)
    cipher.iv = digest[0...IV_LENGTH]
    begin
      decrypted = cipher.update(data)
      decrypted << cipher.final
    rescue OpenSSL::OpenSSLError, TypeError
      return nil
    end
    decrypted
  end

  def self.encrypt64(key, data)
    Base64.encode64(encrypt(key, data))
  end

  def self.decrypt64(key, data)
    decrypt(key, Base64.decode64(data))
  end

  # multi_decrypt uses the keys in order to decrypt data
  # useful for key rotation
  # WARNING notice that it may decrypt to some arbitrary data using the wrong
  # key, but it's up to the downstream to validate the correctness of the data
  def self.multi_decrypt(keys, data)
    keys.map { |key| decrypt(key, data) }
  end

  def self.multi_decrypt64(keys, data)
    keys.map { |key| decrypt64(key, data) }
  end
end

# Simplebox https://github.com/cryptosphere/rbnacl/wiki/SimpleBox
# The RbNaCl::SimpleBox class provides a simple, easy-to-use cryptographic
# API where all of the hard decisions have been made for you in advance.
# key must be 32 bytes.
module SimpleboxCryptr
  def self.gen_key
    SecureRandom.base64(24) # the returned key is 32 bytes, 32 * 0.75 = 24
  end

  def self.encrypt(key, data)
    box = RbNaCl::SimpleBox.from_secret_key(key.force_encoding('BINARY'))
    box.encrypt(data.force_encoding('BINARY'))
  end

  def self.decrypt(key, data)
    box = RbNaCl::SimpleBox.from_secret_key(key.force_encoding('BINARY'))
    box.decrypt(data.force_encoding('BINARY'))
  rescue RbNaCl::CryptoError
    nil
  end

  def self.encrypt64(key, data)
    Base64.encode64(encrypt(key, data))
  end

  def self.decrypt64(key, data)
    decrypt(key, Base64.decode64(data))
  end

  def self.multi_decrypt(keys, data)
    keys.each do |key|
      d = decrypt(key, data)
      return d if d
    end
    nil
  end

  def self.multi_decrypt64(keys, data)
    keys.each do |key|
      d = decrypt64(key, data)
      return d if d
    end
    nil
  end
end
