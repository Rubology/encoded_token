
module CipherTests
  class PaddingTest < MinitestBase
  
    let(:seed)   { 555555 }
    let(:cipher) { EncodedToken::Cipher.new(seed) }
    
    describe ':padding' do
      it 'returns a fixed padding size for the root key' do
        padding = cipher.padding
        
        5.times do
          cipher.rotate_keys!
          assert_equal padding, cipher.padding
        end
      end
    end
  end
end
