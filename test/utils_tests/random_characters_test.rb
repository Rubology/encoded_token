
module UtilsTests
  class RandomCharactersTest < MinitestBase
  
    describe ':random_characters' do
      let(:utils) { (Class.new { include EncodedToken::Utils }).new }
      
      it 'generates string of correct length' do
        assert_equal 5, utils.send(:random_characters, 5).length
        assert_equal 10, utils.send(:random_characters, 10).length
      end
  
      it 'generates alphanumeric characters only' do
        assert_match /^[A-Za-z0-9]+$/, utils.send(:random_characters, 20)
      end
    end
  end
end
