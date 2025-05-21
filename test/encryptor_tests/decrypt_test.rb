
module EncryptorTests
  class DecryptTest < MinitestBase

    let(:cipher)      { EncodedToken::Cipher.new(555555) }
    let(:encryptor)   { EncodedToken::Encryptor.new(cipher) }
    let(:clear_text)  { SecureRandom.hex(100) }
    let(:cipher_text) { encryptor.encrypt(clear_text) }

    describe ':decrypt' do
      it 'decrypts a string using the given cipher' do
        refute_equal clear_text, cipher_text
        assert_equal clear_text, encryptor.decrypt(cipher_text)
      end

      it 'fails if a character is not hexadecimal' do
        bad_text = cipher_text + 'g'
        error_klass, message = error_for(:invalid_encryption_char)

        err = assert_raises(error_klass) do
          encryptor.encrypt(bad_text)
        end
        assert_match(/#{message}/, err.message)
      end
    end
  end
end
