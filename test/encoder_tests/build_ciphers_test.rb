
module EncoderTests
  class BuildCiphersTest < MinitestBase
    
    # = :build_ciphers!!
    # ======================================================================
    
    describe ':build_ciphers!' do
      let(:encoder) { EncodedToken::Encoder }
      
      it "builds the default encoding cipher" do
        reset_configuration!
        
        config = EncodedToken::Configuration.instance
        config.seed = 555555
        
        refute encoder.encoding_cipher
        assert encoder.build_ciphers!
        assert encoder.encoding_cipher
      end
      
      
      it "builds a list of ciphers for decoding" do
        reset_configuration!
        
        config = EncodedToken::Configuration.instance
        config.seed = 555555
        config.add_expiring_seed(10000001, Time.now + 3600, 12)
        config.add_expiring_seed(10000002, Time.now + 3600, 13)
        config.add_expiring_seed(10000003, Time.now + 3600, 14)
        
        assert encoder.decoding_ciphers.empty?
        assert encoder.build_ciphers!
        assert_equal 4, encoder.decoding_ciphers.size
      end
      
      it "ignores expired seeds" do
        reset_configuration!
        
        config = EncodedToken::Configuration.instance
        config.seed = 555555
        config.add_expiring_seed(10000001, Time.now + 3600, 12)
        config.add_expiring_seed(10000002, Time.now + 3600, 13)
        config.add_expiring_seed(10000003, Time.now - 600, 14)
        
        assert encoder.decoding_ciphers.empty?
        assert encoder.build_ciphers!
        assert_equal 3, encoder.decoding_ciphers.size
      end
      
      it "fails when the seed is not set" do
        reset_configuration!
        
        error_klass, message = error_for(:seed_not_set)

        err = assert_raises(error_klass) do
          encoder.build_ciphers!
        end
        assert_match(/#{message}/, err.message)
      end
    end
  end
end
