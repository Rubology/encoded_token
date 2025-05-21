
module EncoderTests
  class EncodingCipherTest < MinitestBase
    
    def setup
      refresh_configuration!
    end
    
    # = :encoding_cipher
    # ======================================================================
    
    describe ':encoding_cipher' do
      let(:encoder) { EncodedToken::Encoder }
      
      it "return the cipher used for encoding" do
        reset_configuration!
        
        config = EncodedToken::Configuration.instance
        config.seed = 555555
        encoder.build_ciphers!
        
        cipher = encoder.encoding_cipher
        assert cipher
        assert_kind_of EncodedToken::Cipher, cipher
      end
      
      
      it "return a copy the encoding cipher" do
        reset_configuration!
        
        config = EncodedToken::Configuration.instance
        config.seed = 555555
        encoder.build_ciphers!
        
        orig_cipher = encoder.instance_variable_get(:@encoding_cipher)
        copy_cipher = encoder.encoding_cipher
        
        refute_equal orig_cipher.object_id, copy_cipher.object_id
      end
      
      it "retruns nil if the encoding cipher is mising" do
        reset_configuration!
        
        refute encoder.encoding_cipher
      end
    end
  end
end
