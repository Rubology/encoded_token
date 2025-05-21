
module EncryptorTests
  class PaddingTest < MinitestBase

    let(:cipher)    { EncodedToken::Cipher.new(555555) }

    describe ':padding' do
      it 'delegates to the cipher' do
        encryptor = EncodedToken::Encryptor.new(cipher)
        assert_equal cipher.padding, encryptor.padding
      end
    end
  end
end
