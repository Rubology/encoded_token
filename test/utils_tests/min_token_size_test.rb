
module UtilsTests
  class MinTokenSizeTest < MinitestBase
  
    describe ':min_token_size' do
      let(:utils) { (Class.new { include EncodedToken::Utils }).new }
      
      it 'returns the encoder minimum token size' do
        assert_equal EncodedToken::Encoder.min_token_size, utils.send(:__min_token_size)
      end
    end
  end
end
