
module CipherTests
  class SeedTest < MinitestBase
  
    let(:seed)   { 555555 }
    let(:cipher) { EncodedToken::Cipher.new(seed) }
    
    describe ':seed' do
      it 'returns the seed used to initialize the cipher' do
        assert_equal seed, cipher.seed
      end
    end
  end
end
