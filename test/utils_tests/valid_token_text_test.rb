
class ValidTokenTextTest < MinitestBase

  describe ':valid_token_text?' do
    let(:utils) { (Class.new { include EncodedToken::Utils }).new }
    
    it 'returns true for valid token strings' do
      assert utils.send(:valid_token_text?, "abc123ABC")
      assert utils.send(:valid_token_text?, "XYZ789def")
    end

    it 'returns false for invalid token strings' do
      refute utils.send(:valid_token_text?, "abc!@#")
      refute utils.send(:valid_token_text?, "xyz$%^")
    end
  end
end
