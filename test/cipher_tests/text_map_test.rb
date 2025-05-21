
module CipherTests
  class TextMapTest < MinitestBase
  
    let(:seed)   { 555555 }
    let(:cipher) { EncodedToken::Cipher.new(seed) }
    
    describe ':text_map' do
      it 'returns a positional hash for the current key text' do
        5.times do
          text = cipher.text
          map  = cipher.text_map
          
          assert_kind_of Hash, map
          assert_equal text, map.keys.join
          
          map.each do |char, idx|
            assert_equal char, text[idx]
          end
          
          cipher.rotate_keys!
        end
      end
    end
  end
end
