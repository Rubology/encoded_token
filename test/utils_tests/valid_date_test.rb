
module UtilsTests
  class ValidDateTest < MinitestBase
  
    describe ':valid_date?' do
      let(:utils) { (Class.new { include EncodedToken::Utils }).new }
      
      it 'returns true for a Date object' do
        assert utils.send(:valid_date?, Date.today)
        # expect(utils.send(:valid_date?, Date.today)).to be true
      end
  
      it 'returns true for a Time object' do
        assert utils.send(:valid_date?, Time.now)
        # expect(utils.send(:valid_date?, Time.now)).to be true
      end
  
      it 'returns true for a DateTime object' do
        assert utils.send(:valid_date?, DateTime.now)
      end
  
      it 'returns false for a nil value' do
        refute utils.send(:valid_date?, nil)
      end
  
      it 'returns false for non-date/time objects' do
        refute utils.send(:valid_date?, "2024-01-01")
        refute utils.send(:valid_date?, 123)
        refute utils.send(:valid_date?, Object.new)
      end
    end
  end
end
