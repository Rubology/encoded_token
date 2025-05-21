
module UtilsTests
  class MaxInputSizeTest < MinitestBase
  
    describe ':max_input_size' do
      let(:utils) { (Class.new { include EncodedToken::Utils }).new }
      
      it 'returns the encoder maximum input size' do
        assert_equal EncodedToken::Encoder.max_input_size, utils.send(:__max_input_size)
      end
    end
  end
end
