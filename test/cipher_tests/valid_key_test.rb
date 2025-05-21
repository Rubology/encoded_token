
module CipherTests
  class ValidKeyTest < MinitestBase
  
    let(:seed)   { 555555 }
    let(:cipher) { EncodedToken::Cipher.new(seed) }
    
    describe ':valid_key?' do
      it 'returns true if the given key is in the key-list' do
        4.times do
          key = cipher.send(:keys).sample
          assert cipher.valid_key?(key)
        end
      end
      
      it 'returns false if the given key is not in the key-list' do
        4.times do
          available_keys = ('a'..'z').to_a - cipher.send(:keys)
          key = available_keys.sample
          refute cipher.valid_key?(key)
        end
      end
    end
  end
end
