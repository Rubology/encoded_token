
module ConfigurationTests
  class SeedTest < MinitestBase
    let(:config)       { EncodedToken::Configuration.send(:new) }
  
    # = :seed
    # ======================================================================
  
    describe ':seed' do
      it 'returns the seed' do
        assert_nil config.seed
        
        config.seed = 555555
        
        assert_equal 555555, config.seed
      end
    end
  
    # = :seed=
    # ======================================================================
  
    describe ':seed=' do
      # = On Success
      # ======================================================================
  
      context "on success" do
        it 'accepts an Integer value' do
          config.seed = 123
          assert_equal 123, config.seed
        end
  
        it 'accepts a String value' do
          config.seed = '234'
          assert_equal 234, config.seed
        end
  
        it 'sets the seed if not already set' do
          config.seed = 123
          assert_equal 123, config.seed
        end
  
        it 'replaces an existing seed with the new one' do
          config.seed = 123
          assert_equal 123, config.seed
          config.seed = 456
          assert_equal 456, config.seed
        end
  
        it 'sets the seed to absolute integer' do
          config.seed = -987
          assert_equal 987, config.seed
        end
      end # on success
      
      
      # = On Failure
      # ======================================================================
  
      context "on failure" do
        it "fails when the configuration is locked" do
          config.stubs(:locked?).returns(true)
          assert_raises *error_for(:no_config_change_allowed) do
            config.seed = 777777
          end
        end
        
        it "fails with a non-integer input size" do
          assert_raises *error_for(:invalid_seed) do
            config.seed = 'ouch!'
          end
        end
        
        it "fails with a nil input size" do
          assert_raises *error_for(:invalid_seed) do
            config.seed = nil
          end
        end
      end
      
    end
  end
end
