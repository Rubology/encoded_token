
module EncodedTokenTests
  class DecodeTest < MinitestBase
  
    describe ':decode' do
      it 'calls :decode on the encoder' do
        refresh_configuration!
        EncodedToken::Encoder.expects(:decode).once.returns(true)
        EncodedToken.decode("This is a test string")
      end
    end
    
    describe ':decode!' do
      it 'calls :decode! on the encoder' do
        refresh_configuration!
        EncodedToken::Encoder.expects(:decode!).once.returns(true)
        EncodedToken.decode!("This is a test string")
      end
    end
  end
end
