
module Utf8EncodingTests
  class EncodeTest < MinitestBase
    
    # = :encode
    # ======================================================================
    
    describe ':encode' do
      before(:each) { refresh_configuration! }
      
      let(:encoder)      { EncodedToken::Encoder::Utf8Encoder }
      let(:clear_text)   { "This is a Tést Střinğ 🤪" }
      
      context "on success" do
        it "encodes a text input" do
          encoded_token = encoder.encode(clear_text)
          assert encoded_token
          refute_equal clear_text, encoded_token
        end
        
        it "encodes a decodable token" do
          encoded_token = encoder.encode(clear_text)
          assert_equal clear_text, EncodedToken::Encoder::Utf8Decoder.decode(encoded_token)
        end
        
        it "encodes the same input to 90% different token each time" do
          tokens = []
          100.times { tokens << encoder.encode(clear_text) }
          assert tokens.uniq.size >= 90
        end
        
        it "adds additional pading if the token is too small" do
          encoded_token = encoder.encode('a')
          assert_equal 'a', EncodedToken::Encoder::Utf8Decoder.decode(encoded_token)
        end
      end # on success
      
      context "on failure" do
        it "fails with an empty input" do
          error_klass, message = error_for(:invalid_utf8_input)

          err = assert_raises(error_klass) do
            encoder.encode('')
          end
          assert_match(/#{message}/, err.message)
        end
        
        it "fails with a too large input" do
          big_text = "a" * (EncodedToken::Encoder.max_input_size + 1)
          error_klass, message = error_for(:invalid_utf8_input)

          err = assert_raises(error_klass) do
            encoder.encode(big_text)
          end
          assert_match(/#{message}/, err.message)
        end
      end # on failure
    end
  end
end
