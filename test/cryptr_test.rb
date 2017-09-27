require 'test_helper'
require 'securerandom'

class CryptrTest < Minitest::Test
  def test_it_can_decrypt_encrypt_random_data
    100.times do
      data = SecureRandom.base64
      key = 'some_key'
      assert data == Cryptr.decrypt(key, Cryptr.encrypt(key, data))
    end
  end

  def test_it_can_decrypt_encrypt_random_data_base64
    100.times do
      data = SecureRandom.base64
      key = 'some_key'
      assert data == Cryptr.decrypt64(key, Cryptr.encrypt64(key, data))
    end
  end
end
