
module ConfigurationTests
  class InitializeTest < MinitestBase
  
    describe ':initialize' do
      let (:config) { EncodedToken::Configuration.send(:new) }
      
      it 'sets the default cipher count' do
        assert_equal EncodedToken::Configuration::DEFAULT_CIPHER_COUNT, config.cipher_count
      end
      
      it 'sets the default maximum input size' do
        assert_equal EncodedToken::Configuration::DEFAULT_MAX_INPUT_SIZE, config.max_input_size
      end
      
      it 'sets the default minimum token size' do
        assert_equal EncodedToken::Configuration::DEFAULT_MIN_TOKEN_SIZE, config.min_token_size
      end
      
      it 'sets expiring seeds to an empty hash' do
        assert_kind_of Hash, config.expiring_seeds
        assert_empty config.expiring_seeds
      end
      
      it 'sets the configuration to unlocked' do
        config.instance_variable_set(:@locked, false)
        assert_equal false, config.locked?
        assert_equal true,  config.unlocked?
      end
    end
  end
end
