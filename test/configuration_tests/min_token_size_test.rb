
module ConfigurationTests
  class MinTokenSizeTest < MinitestBase
    let(:config)       { EncodedToken::Configuration.send(:new) }
  
    # = :min_token_size
    # ======================================================================
  
    describe ':min_token_size' do
      it 'returns the min token size' do
        assert_equal EncodedToken::Configuration::DEFAULT_MIN_TOKEN_SIZE, config.min_token_size
        
        new_size              = EncodedToken::Configuration::DEFAULT_MIN_TOKEN_SIZE + 33
        config.min_token_size = new_size
        
        assert_equal new_size, config.min_token_size
      end
    end
  
    # = :min_token_size=
    # ======================================================================
  
    describe ':min_token_size=' do
      # = On Success
      # ======================================================================
  
      context "on success" do
        it "sets the min token size" do
          assert_empty config.expiring_seeds
          
          refute_equal 123, config.min_token_size
          config.min_token_size = 123
          assert_equal 123, config.min_token_size
        end
        
        it 'works with an integer expiring seed' do
          config.min_token_size = 54321
          assert_equal 54321, config.min_token_size
        end
  
        it 'works with an string expiring seed' do
          config.min_token_size = '12345'
          assert_equal 12345, config.min_token_size
        end
  
        it 'converts the expiring seed to an absolute Integer' do
          config.min_token_size = -555
          assert_equal 555, config.min_token_size
        end
      end # on success
      
      
      # = On Failure
      # ======================================================================
  
      context "on failure" do
        it "fails when the configuration is locked" do
          config.stubs(:locked?).returns(true)
          assert_raises *error_for(:no_config_change_allowed) do
            config.min_token_size = 123
          end
        end
        
        it "fails with a non-integer input size" do
          assert_raises *error_for(:invalid_min_token_size) do
            config.min_token_size = 'ouch!'
          end
        end
        
        it "fails with an input size of zero" do
          assert_raises *error_for(:invalid_min_token_size) do
            config.min_token_size = 0
          end
        end
      end
      
    end
  end
end
