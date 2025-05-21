
module UtilsTests
  class RandomHexTest < MinitestBase
  
    describe ':random_hex' do
      let(:utils)     { (Class.new { include EncodedToken::Utils }).new }
      let(:hex_chars) { EncodedToken::Cipher::HEX_CHARS }
      
      it 'generates string of correct length' do
        assert_equal 5, utils.send(:random_hex, 5).length
        assert_equal 10, utils.send(:random_hex, 10).length
      end
  
      it 'generates HEX_TEXT characters only' do
        hex_str = utils.send(:random_hex, 20)
        assert_empty hex_str.chars.reject{ |c| hex_chars.include?(c) }
      end
      
      it 'returns an empty string when size is 0' do
        assert_equal '', utils.send(:random_hex, 0)
      end
  
      it 'returns different results on multiple calls' do
        results = Array.new(5) { utils.send(:random_hex, 10) }
        # Not guaranteed but highly probable that multiple calls differ
        assert results.uniq.size > 1
      end
    end
  end
end
