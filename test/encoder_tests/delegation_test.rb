
module EncoderTests
  class DelegationTest < MinitestBase
    
    def setup
      refresh_configuration!
    end
    
    # = :min_token_size?
    # ======================================================================
    
    describe ':min_token_size?' do
      let(:encoder) { EncodedToken::Encoder }
      
      it "delegate result to configuration" do
        EncodedToken::Configuration.instance.expects(:min_token_size).once.returns(55)
        assert_equal 55, encoder.min_token_size
      end
    end
    
    
    # = :max_input_size?
    # ======================================================================
    
    describe ':max_input_size?' do
      let(:encoder) { EncodedToken::Encoder }
      
      it "delegate result to configuration" do
        EncodedToken::Configuration.instance.expects(:max_input_size).once.returns(33)
        assert_equal 33, encoder.max_input_size
      end
    end
  end
end
