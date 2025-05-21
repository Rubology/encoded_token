
module EncodedTokenTests
  class ConfigureTest < MinitestBase
  
    describe ':configure' do
      it 'sets the configuration from a given block' do
        reset_configuration!
        
        EncodedToken.configure do |config|
          config.seed = 54321
        end
        assert_equal 54321, EncodedToken::Configuration.instance.seed
      end
  
      it 'builds the ciphers' do
        reset_configuration!
        assert_nil   EncodedToken::Encoder.encoding_cipher
        assert_empty EncodedToken::Encoder.decoding_ciphers
        
        EncodedToken.configure do |config|
          config.seed = 54321
        end
        
        assert EncodedToken::Encoder.encoding_cipher
        assert EncodedToken::Encoder.decoding_ciphers
        
      end
    end
  end
end
