
module ConfigurationTests
  class ExpiringSeedsTest < MinitestBase
    let(:config)       { EncodedToken::Configuration.send(:new) }
    let(:expires_on)   { Time.now + 3600 }
    let(:cipher_count) { rand(8..EncodedToken::Cipher::MAX_CIPHER_COUNT) }
  
    # = :expiring_seeds
    # ======================================================================
  
    describe ':expiring_seeds' do
      it "retuns an empty Hash when no expiring seeds" do
        assert_kind_of Hash, config.expiring_seeds
        assert_empty config.expiring_seeds
      end
      
      it "returns a hash of recorder expiring seeds" do
        config.add_expiring_seed(10000001, expires_on, 13)
        config.add_expiring_seed(10000002, expires_on, 14)
        config.add_expiring_seed(10000003, expires_on, 15)
        
        assert_equal 3, config.expiring_seeds.size
        assert_equal 13, config.expiring_seeds[10000001][:cipher_count]
        assert_equal 14, config.expiring_seeds[10000002][:cipher_count]
        assert_equal 15, config.expiring_seeds[10000003][:cipher_count]
      end
    end
  
    # = :add_expiring_seed
    # ======================================================================
  
    describe ':add_expiring_seed' do
      # = On Success
      # ======================================================================
  
      context "on success" do
        it "adds seed to expiring_seeds hash with integer key" do
          assert_empty config.expiring_seeds
          
          config.add_expiring_seed(12121212, expires_on, cipher_count)
          
          assert_equal 1,           config.expiring_seeds.size
          assert_equal cipher_count,    config.expiring_seeds[12121212][:cipher_count]
          assert_equal expires_on.to_i, config.expiring_seeds[12121212][:expires_on].to_i
        end
        
        it 'works with an integer expiring seed' do
          config.add_expiring_seed(987, expires_on)
          assert_equal expires_on, config.expiring_seeds[987][:expires_on]
        end
  
        it 'works with an string expiring seed' do
          config.add_expiring_seed('789', expires_on)
          assert_equal expires_on, config.expiring_seeds[789][:expires_on]
        end
  
        it 'converts the expiring seed to an absolute Integer' do
          config.add_expiring_seed(-555, expires_on)
          assert_equal expires_on, config.expiring_seeds[555][:expires_on]
        end
      end # on success
      
      
      # = On Failure
      # ======================================================================
  
      context "on failure" do
        it "fails when the configuration is locked" do
          config.stubs(:locked?).returns(true)
          assert_raises *error_for(:no_config_change_allowed) do
            config.add_expiring_seed(12121212, expires_on, cipher_count)
          end
        end
        
        it 'fails with an invalid expiring seed' do
          assert_raises *error_for(:invalid_expiry_argument) do
            config.add_expiring_seed('invalid', expires_on, cipher_count)
          end
        end
  
        it "fails with an invalid expiry date" do
          assert_raises *error_for(:invalid_expiry_argument) do
            config.add_expiring_seed(12121212, "Tomorrow", cipher_count)
          end
        end
        
        it "fails with an invalid cipher count" do
          assert_raises *error_for(:invalid_expiry_argument) do
            config.add_expiring_seed(12121212, expires_on, "test cipher count")
          end
        end
      end
      
    end
  end
end
