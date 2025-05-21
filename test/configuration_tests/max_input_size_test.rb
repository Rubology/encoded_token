
module ConfigurationTests
  class MaxInputSizeTest < MinitestBase
    let(:config)       { EncodedToken::Configuration.send(:new) }
  
    # = :max_input_size
    # ======================================================================
  
    describe ':max_input_size' do
      it 'returns the max input size' do
        assert_equal EncodedToken::Configuration::DEFAULT_MAX_INPUT_SIZE, config.max_input_size
        
        new_size              = EncodedToken::Configuration::DEFAULT_MAX_INPUT_SIZE + 33
        config.max_input_size = new_size
        
        assert_equal new_size, config.max_input_size
      end
    end
  
    # = :max_input_size=
    # ======================================================================
  
    describe ':max_input_size=' do
      # = On Success
      # ======================================================================
  
      context "on success" do
        it "sets the max input size" do
          assert_empty config.expiring_seeds
          
          refute_equal 55, config.max_input_size
          config.max_input_size = 55
          assert_equal 55, config.max_input_size
        end
        
        it 'works with an integer expiring seed' do
          config.max_input_size = 54321
          assert_equal 54321, config.max_input_size
        end
  
        it 'works with an string expiring seed' do
          config.max_input_size = '12345'
         assert_equal 12345, config.max_input_size
        end
  
        it 'converts the expiring seed to an absolute Integer' do
          config.max_input_size = -555
          assert_equal 555, config.max_input_size
        end
      end # on success
      
      
      # = On Failure
      # ======================================================================
  
      context "on failure" do
        it "fails when the configuration is locked" do
          config.stubs(:locked?).returns(true)
          assert_raises *error_for(:no_config_change_allowed) do
            config.max_input_size = 55
          end
        end
        
        it "fails with a non-integer input size" do
          assert_raises *error_for(:invalid_cipher_count) do
            config.max_input_size = 'ouch!'
          end
        end
        
        it "fails with an input size of zero" do
          assert_raises *error_for(:invalid_cipher_count) do
            config.max_input_size = 0
          end
        end
      end
      
    end
  end
end
