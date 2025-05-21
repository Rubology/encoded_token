
module CipherTests
  class TextTest < MinitestBase
  
    let(:seed)   { 555555 }
    let(:cipher) { EncodedToken::Cipher.new(seed) }
    
    describe ':text' do
      it 'returns the cipher text for the current rotation key' do
        texts = [cipher.text]
        5.times do
          cipher.rotate_keys!
          refute_includes texts, cipher.text
          texts << cipher.text
        end
      end
    end
  end
end
