
module EncryptorTests
  class EncryptTest < MinitestBase

    let(:cipher)    { EncodedToken::Cipher.new(555555) }

    describe ':encrypt' do
      it 'encrypts a string using the given cipher' do
        encryptor     = EncodedToken::Encryptor.new(cipher)
        original_str  = SecureRandom.hex(23)
        encrypted_str = encryptor.encrypt(original_str)
        refute_equal original_str, encrypted_str
      end
      
      it 'produces a string that can be decrypted' do
        encryptor     = EncodedToken::Encryptor.new(cipher)
        original_str  = SecureRandom.hex(23)
        encrypted_str = encryptor.encrypt(original_str)

        refute_equal original_str, encrypted_str

        decrypted_str = encryptor.decrypt(encrypted_str)
        assert_equal original_str, decrypted_str
      end

      it 'fails if a character is not hexadecimal' do
        encryptor            = EncodedToken::Encryptor.new(cipher)
        error_klass, message = error_for(:invalid_encryption_char)

        err = assert_raises(error_klass) do
          encryptor.encrypt('g')
        end
        assert_match(/#{message}/, err.message)
      end
    end
  end
end
