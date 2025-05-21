
module EncodedTokenTests
  class EncodeTest < MinitestBase
  
    describe ':encode' do
      it 'calls :encode on the encoder' do
        refresh_configuration!
        EncodedToken::Encoder.expects(:encode).once.returns(true)
        EncodedToken.encode("This is a test string")
      end
    end
    
    describe ':encode!' do
      it 'calls :encode! on the encoder' do
        refresh_configuration!
        EncodedToken::Encoder.expects(:encode!).once.returns(true)
        EncodedToken.encode!("This is a test string")
      end
    end
  end
end
