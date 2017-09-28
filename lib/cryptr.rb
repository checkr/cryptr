require 'base64'
require 'openssl'

require 'cryptr/version'

# Cryptr is a minimal encryption module that follows the standard of AES-256-CBC
# A random iv is generated each time and prepended to the encrypted message
module Cryptr
  ENCRYPTION_METHOD = 'aes-256-cbc'.freeze
  IV_LENGTH = 16

  # encrypts data with the given key. returns a binary data with the
  # unhashed random iv in the first 16 bytes
  def self.encrypt(key, data)
    cipher = OpenSSL::Cipher::Cipher.new(ENCRYPTION_METHOD)
    cipher.encrypt
    cipher.key = key = OpenSSL::Digest::SHA256.digest(key)
    random_iv = cipher.random_iv
    cipher.iv = OpenSSL::Digest::SHA256.digest(random_iv + key)[0...IV_LENGTH]
    encrypted = cipher.update(data)
    encrypted << cipher.final
    random_iv + encrypted
  end

  def self.decrypt(key, data) # rubocop:disable Metrics/MethodLength
    cipher = OpenSSL::Cipher::Cipher.new(ENCRYPTION_METHOD)
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
end
