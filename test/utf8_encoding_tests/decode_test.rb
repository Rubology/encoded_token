
module Utf8EncodingTests
  class DecodeTest < MinitestBase
    
    # = :decode
    # ======================================================================
    
    describe ':decode' do
      before(:each) { refresh_configuration! }
      
      let(:decoder)       { EncodedToken::Encoder::Utf8Decoder }
      let(:clear_text)    { "This is a Tést Střinğ 🤪" }
      let(:encoded_token) { EncodedToken::Encoder::Utf8Encoder.encode(clear_text) }
      
      context "on success" do
        it "decodes a token" do
          decoded_token = decoder.decode(encoded_token)
          assert decoded_token
          assert_equal clear_text, decoded_token
        end
        
        it "tries with each decoding ciphers" do
          reset_configuration!
          
          orig_seed         = 12345
          new_seed          = 555555
          orig_cipher_count = 22
          new_cipher_count  = 12
          
          EncodedToken::Configuration.instance.seed = orig_seed
          EncodedToken::Configuration.instance.cipher_count = orig_cipher_count
          EncodedToken::Encoder.build_ciphers!
          
          orig_token = EncodedToken::Encoder::Utf8Encoder.encode(clear_text)

          reset_configuration!

          EncodedToken::Configuration.instance.seed         = new_seed
          EncodedToken::Configuration.instance.cipher_count = new_cipher_count
          EncodedToken::Configuration.instance.add_expiring_seed(10000001, Time.now + 3600, 12)
          EncodedToken::Configuration.instance.add_expiring_seed(10000002, Time.now + 3600, 13)
          EncodedToken::Configuration.instance.add_expiring_seed(10000003, Time.now + 3600, 14)
          EncodedToken::Configuration.instance.add_expiring_seed(orig_seed, Time.now + 3600, orig_cipher_count)
          EncodedToken::Encoder.build_ciphers!

          assert_equal clear_text, EncodedToken::Encoder::Utf8Decoder.decode(orig_token)
        end
      end # on success
      
      context "on failure" do
        it "fails with a non-string token" do
          error_klass, message = error_for(:non_string_token)

          err = assert_raises(error_klass) do
            decoder.decode(Date.today)
          end
          assert_match(/#{message}/, err.message)
        end

        it "fails with an invalid token" do
          error_klass, message = error_for(:invalid_token)

          err = assert_raises(error_klass) do
            decoder.decode(encoded_token[0..-2])
          end
          assert_match(/#{message}/, err.message)
        end
        
        it "fails with a invalid token chars" do
          error_klass, message = error_for(:invalid_token_characters)

          err = assert_raises(error_klass) do
            decoder.decode("abcdéfg_")
          end
          assert_match(/#{message}/, err.message)
        end
        
        it "returns nil with an invalid token" do
          invalid_token         = encoded_token
          invalid_token[15..20] = invalid_token[25..30]
          
          assert_nil decoder.decode(invalid_token)
        end
      end # on failure
    end
  end
end
