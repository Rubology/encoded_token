
class ValidUuidFormatTest < MinitestBase

  describe ':valid_uuid_format?' do
    let(:utils)    { (Class.new { include EncodedToken::Utils }).new }
    let(:bad_uuid) { SecureRandom.uuid[0..-2] }

    
    it 'returns true for valid UUIDs' do
      assert utils.send(:valid_uuid_format?, SecureRandom.uuid)
      assert utils.send(:valid_uuid_format?, SecureRandom.uuid)
    end

    it 'returns false for invalid UUIDs' do
      refute utils.send(:valid_uuid_format?, "invalid-uuid")
      refute utils.send(:valid_uuid_format?, bad_uuid)
      refute utils.send(:valid_uuid_format?, "")
    end

    it 'returns false on an error' do
      fake_fail = bad_uuid.dup
      def fake_fail.downcase
        raise NoMethodError
      end
      refute utils.send(:valid_uuid_format?, fake_fail)
    end
  end
end
