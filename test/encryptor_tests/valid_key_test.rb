
module EncryptorTests
  class ValidKeyTest < MinitestBase

    let(:cipher)    { EncodedToken::Cipher.new(555555) }

    describe ':valid_key?' do
      it 'delegates to the cipher' do
        cipher.expects(:valid_key?).once.returns(true)
        encryptor = EncodedToken::Encryptor.new(cipher)
        assert encryptor.valid_key?('a')
      end
    end
  end
end
