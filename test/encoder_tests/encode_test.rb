
module EncoderTests
  class EncodeTest < MinitestBase
    
    def setup
      refresh_configuration!
    end
    
    # = :encode
    # ======================================================================
    
    describe ':encode' do
      let(:encoder)     { EncodedToken::Encoder }
      let(:clear_text) { "This is a Tést Střinğ 🤪" }
      
      it "delegates to :encode!" do
        encoder.expects(:encode!).once.returns(Date.today)
        assert encoder.encode(clear_text)
      end
      
      it "returns a token" do
        assert encoder.encode(clear_text)
      end
      
      it "rescues any error and returns nill" do
        encoder.expects(:encode!).raises(RuntimeError)
        assert_nil encoder.encode(clear_text)
      end
    end
    
    
    # = :encode!
    # ======================================================================
    
    describe ':encode!' do
      before(:each) { refresh_configuration! }
      
      let(:encoder)     { EncodedToken::Encoder }
      let(:clear_text) { "This is a Tést Střinğ 🤪" }
      
      context "on success" do
        it "encodes the clear text" do
          encoded_text = encoder.encode!(clear_text)
          assert encoded_text
          refute_equal clear_text, encoded_text
        end
        
        it "uses the utf8 encoder by default" do
          EncodedToken::Encoder::Utf8Encoder.expects(:encode).once.returns("encoded_text")
          encoder.encode!(clear_text)
        end
        
        it "uses the utf8 encoder with the :utf8 key" do
          EncodedToken::Encoder::Utf8Encoder.expects(:encode).once.returns("encoded_text")
          encoder.encode!(clear_text, :utf8)
        end
        
        it "uses the legacy encoder with the :legacy key" do
          EncodedToken::Encoder::LegacyEncoder.expects(:encode).once.returns("encoded_text")
          encoder.encode!(clear_text, :legacy)
        end
        
        it "produced an encoding that can be decoded" do
          encoded_text = encoder.encode!(clear_text)
          assert encoded_text
          refute_equal clear_text, encoded_text

          decoded_text = encoder.decode!(encoded_text)
          assert_equal clear_text, decoded_text
        end
      end # on success
      
      
      context "on failure" do
        it "fails with an invalid encode key" do
          error_klass, message = error_for(:invalid_encoder)
  
          err = assert_raises(error_klass) do
            encoder.encode!(clear_text, :test)
          end
          assert_match(/#{message}/, err.message)
        end
        
        it "fails if the encoding cipher is not defined" do
          encoder.stubs(:encoding_cipher).returns(nil)
          error_klass, message = error_for(:seed_not_set)
  
          err = assert_raises(error_klass) do
            encoder.encode!(clear_text, :test)
          end
          assert_match(/#{message}/, err.message)
        end
      end
      
    end
  end
end
