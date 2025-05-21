
module EncoderTests
  class CiphersBuiltTest < MinitestBase
    
    # = :ciphers_built?
    # ======================================================================
    
    describe ':ciphers_built?' do
      let(:encoder) { EncodedToken::Encoder }
      
      it "retruns true if the encoding cipher is present" do
        encoder.stubs(:encoding_cipher).returns(Date.today)
        assert encoder.ciphers_built?
      end
      
      it "retruns false if the encoding cipher is mising" do
        encoder.stubs(:encoding_cipher).returns(nil)
        refute encoder.ciphers_built?
      end
    end
  end
end
