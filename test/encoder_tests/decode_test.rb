
module EncoderTests
  class DecodeTest < MinitestBase
    
    def setup
      refresh_configuration!
    end
    
    # = :decode
    # ======================================================================
    
    describe ':decode' do
      let(:encoder)      { EncodedToken::Encoder }
      let(:clear_text)   { "This is a Tést Střinğ 🤪" }
      let(:encoded_text) { encoder.encode!(clear_text) }
      
      it "delegates to :decode!" do
        encoder.expects(:decode!).once.returns(Date.today)
        assert encoder.decode(clear_text)
      end
      
      it "rescues any error and returns nill" do
        encoder.expects(:decode!).raises(RuntimeError)
        assert_nil encoder.decode(clear_text)
      end
    end
    
    
    # = :decode!
    # ======================================================================
    
    describe ':decode!' do
      before(:each) { refresh_configuration! }
      
      let(:encoder)     { EncodedToken::Encoder }
      let(:clear_text) { "This is a Tést Střinğ 🤪" }
      
      context "on success" do
        it "correctly decodes a utf8 encoding" do
          encoded_text = encoder.encode!(clear_text)
          assert_equal clear_text, encoder.decode!(encoded_text)
        end

        it "correctly decodes a legacy encoding" do
          uuid = SecureRandom.uuid
          encoded_text = encoder.encode!(uuid, :legacy)
          assert_equal uuid, encoder.decode!(encoded_text)
        end
      end # on success
      
      
      context "on failure" do
        it "fails with a non-string token" do
          error_klass, message = error_for(:non_string_token)
  
          err = assert_raises(error_klass) do
            encoder.decode!(12345)
          end
          assert_match(/#{message}/, err.message)
        end
        
        it "fails if the encoding cipher is not defined" do
          encoder.stubs(:encoding_cipher).returns(nil)
          error_klass, message = error_for(:seed_not_set)
  
          err = assert_raises(error_klass) do
            encoder.decode!(clear_text)
          end
          assert_match(/#{message}/, err.message)
        end
      end
      
    end
  end
end
