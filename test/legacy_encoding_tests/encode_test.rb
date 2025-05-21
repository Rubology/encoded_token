
module Utf8LegacyEncodingTests
  class EncodeTest < MinitestBase
    
    # = :encode
    # ======================================================================
    
    describe ':encode' do
      before(:each) { refresh_configuration! }
      
      let(:encoder)   { EncodedToken::Encoder::LegacyEncoder }
      let(:uuid)      { SecureRandom.uuid }
      
      context "on success" do
        it "encodes an integer id input" do
          encoded_token = encoder.encode(12345)
          assert encoded_token
          refute_equal 12345, encoded_token
        end
        
        it "encodes a string id input" do
          encoded_token = encoder.encode("12345")
          assert encoded_token
          refute_equal "12345", encoded_token
        end
        
        it "encodes a UUID input" do
          encoded_token = encoder.encode(uuid)
          assert encoded_token
          refute_equal uuid, encoded_token
        end
        
        it "encodes a decodable token" do
          encoded_token = encoder.encode(uuid)
          assert_equal uuid, EncodedToken::Encoder::LegacyDecoder.decode(encoded_token)
        end
        
        it "encodes the same input to 90% different token each time" do
          tokens = []
          100.times { tokens << encoder.encode(uuid) }
          assert tokens.uniq.size >= 90
        end
      end # on success
      
      context "on failure" do
        it "fails with an empty input" do
          error_klass, message = error_for(:invalid_id)

          err = assert_raises(error_klass) do
            encoder.encode('')
          end
          assert_match(/#{message}/, err.message)
        end

        it "fails with a non-hex string input" do
          error_klass, message = error_for(:invalid_id)

          err = assert_raises(error_klass) do
            encoder.encode('1234x567')
          end
          assert_match(/#{message}/, err.message)
        end

        it "fails with a non-integer or UUID input" do
          error_klass, message = error_for(:invalid_id)

          err = assert_raises(error_klass) do
            encoder.encode(Date.today)
          end
          assert_match(/#{message}/, err.message)
        end

        it "fails with an invalid UUID format" do
          error_klass, message = error_for(:invalid_id)

          err = assert_raises(error_klass) do
            encoder.encode(uuid + 'a')
          end
          assert_match(/#{message}/, err.message)
        end
      end # on failure
    end
  end
end
