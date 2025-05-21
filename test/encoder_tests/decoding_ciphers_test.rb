
module EncoderTests
  class DecodingCiphersTest < MinitestBase
    
    def setup
      refresh_configuration!
    end
    
    # = :decoding_ciphers
    # ======================================================================
    
    describe ':decoding_ciphers' do
      let(:encoder) { EncodedToken::Encoder }
      
      it "returns an empty array if no ciphers built" do
        reset_configuration!
        
        ciphers = encoder.decoding_ciphers
        assert_kind_of Array, ciphers
        assert ciphers.empty?
      end
      
      it "returns an duplicate ciphers" do
        reset_configuration!
        
        config = EncodedToken::Configuration.instance
        config.seed = 555555
        config.add_expiring_seed(10000001, Time.now + 3600, 12)
        config.add_expiring_seed(10000002, Time.now + 3600, 13)
        config.add_expiring_seed(10000003, Time.now + 3600, 14)
        assert encoder.build_ciphers!
        
        orig_ciphers = encoder.instance_variable_get(:@decoding_ciphers)
        copy_ciphers = encoder.decoding_ciphers
        
        assert_equal 4, copy_ciphers.size
        orig_ciphers.each_with_index do |orig_cipher, idx|
          assert_equal copy_ciphers[idx].seed, orig_cipher.seed
          refute_equal orig_ciphers.object_id, copy_ciphers.object_id
        end
      end
    end
  end
end
