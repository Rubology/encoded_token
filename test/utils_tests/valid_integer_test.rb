
class ValidIntegerTest < MinitestBase

  describe ':valid_integer?' do
    let(:utils) { (Class.new { include EncodedToken::Utils }).new }
    
     it 'returns true for valid integers' do
      assert utils.send(:valid_integer?, "123")
      assert utils.send(:valid_integer?, 456)
      assert utils.send(:valid_integer?, "0")
    end

    it 'returns false for invalid integers' do
      refute utils.send(:valid_integer?, "12.3")
      refute utils.send(:valid_integer?, "abc")
      refute utils.send(:valid_integer?, "")
    end
  end
end
