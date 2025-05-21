
class ValidHexTextTest < MinitestBase

  describe ':valid_hex_text?' do
    let(:utils) { (Class.new { include EncodedToken::Utils }).new }
    
    it 'returns true for valid hex strings' do
      assert utils.send(:valid_hex_text?, "123abc")
      assert utils.send(:valid_hex_text?, "ABCDEF")
      assert utils.send(:valid_hex_text?, "123ABC")
    end

    it 'returns false for invalid hex strings' do
      refute utils.send(:valid_hex_text?, "123g")
      refute utils.send(:valid_hex_text?, "xyz")
      refute utils.send(:valid_hex_text?, "!@#")
    end
  end
end
