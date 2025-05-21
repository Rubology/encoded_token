
module ConfigurationTests
  class CipherCountTest < MinitestBase
    let(:config)       { EncodedToken::Configuration.send(:new) }
  
    # = :cipher_count
    # ======================================================================
  
    describe ':cipher_count' do
      it 'returns the cipher count' do
        assert_equal EncodedToken::Configuration::DEFAULT_CIPHER_COUNT, config.cipher_count
        
        new_count           = rand(8..EncodedToken::Cipher::MAX_CIPHER_COUNT)
        config.cipher_count = new_count
        
        assert_equal new_count, config.cipher_count
      end
    end
  
    # = :cipher_count=
    # ======================================================================
  
    describe ':cipher_count=' do
      # = On Success
      # ======================================================================
  
      context "on success" do
        it "sets the cipher count" do
          assert_empty config.expiring_seeds
          
          refute_equal 12, config.cipher_count
          config.cipher_count = 12
          assert_equal 12, config.cipher_count
        end
        
        it 'works with an integer cipher count' do
          config.cipher_count = 54
          assert_equal 54, config.cipher_count
        end
  
        it 'works with an string cipher count' do
          config.cipher_count = '13'
          assert_equal 13, config.cipher_count
        end
  
        it 'converts the cipher count to an absolute Integer' do
          config.cipher_count = -55
          assert_equal 55, config.cipher_count
        end
      end # on success
      
      
      # = On Failure
      # ======================================================================
  
      context "on failure" do
        it "fails when the configuration is locked" do
          config.stubs(:locked?).returns(true)
          assert_raises *error_for(:no_config_change_allowed) do
            config.cipher_count = 30
          end
        end
        
        it "fails with an invalid cipher count" do
          assert_raises *error_for(:invalid_cipher_count) do
            config.cipher_count = 'ouch!'
          end
        end
        
        it "fails with a too-low cipher count" do
          assert_raises *error_for(:invalid_cipher_count) do
            config.cipher_count = 0
          end
        end
        
        it "fails with a too-large cipher count" do
          assert_raises *error_for(:invalid_cipher_count) do
            config.cipher_count = EncodedToken::Cipher::MAX_CIPHER_COUNT + 1
          end
        end
      end
      
    end
  end
end
