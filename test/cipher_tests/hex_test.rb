
module CipherTests
  class HexTest < MinitestBase
  
    let(:seed)   { 555555 }
    let(:cipher) { EncodedToken::Cipher.new(seed) }
    
    # = :hex_text
    # ======================================================================

    describe ':hex_text' do
      it 'returns a string of available hex characters' do
        assert_equal EncodedToken::Cipher::HEX_TEXT, cipher.hex_text
      end
    end

  
    # = :hex_map
    # ======================================================================

    describe ':text_map' do
      it 'returns a positional hash for the hex text' do
        hex_text = cipher.hex_text
        map      = cipher.hex_map
        
        assert_kind_of Hash, map
        assert_equal hex_text, map.keys.join
        
        map.each do |char, idx|
          assert_equal char, hex_text[idx]
        end
      end
    end
  end
end
