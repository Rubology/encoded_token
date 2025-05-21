
module EncryptorTests
  class InitializeTest < MinitestBase

    let(:cipher) { EncodedToken::Cipher.new(555555) }

    describe ':initialize' do
      it 'sets the root key from the cipher if no root key is provided' do
        encryptor = EncodedToken::Encryptor.new(cipher)
        
        assert_equal cipher.root_key, encryptor.key
      end

      it 'sets the root key and validates it if a root key is provided' do
        cipher.stubs(:valid_key?).returns(true)
        random_key = cipher.send(:keys).sample

        encryptor = EncodedToken::Encryptor.new(cipher, random_key)

        assert_equal random_key, encryptor.key
      end

      it 'fails if an invalid root key is provided' do
        cipher.stubs(:valid_key?).returns(false)
        
        error_klass, message = error_for(:invalid_root_key)

        err = assert_raises(error_klass) do
          EncodedToken::Encryptor.new(cipher, 'invalid_key')
        end
        assert_match(/#{message}/, err.message)
      end
    end

    describe ':key' do
      it 'returns the root key' do
        cipher.stubs(:root_key).returns('some_key')
        encryptor = EncodedToken::Encryptor.new(cipher)
        assert_equal 'some_key', encryptor.key
      end
    end
  end
end
