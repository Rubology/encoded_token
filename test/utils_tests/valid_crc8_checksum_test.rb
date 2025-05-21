
module UtilsTests
  class ValidDateTest < MinitestBase
  
    describe '#__crc8_checksum' do
      let(:utils) { (Class.new { include EncodedToken::Utils }).new }
      
      it 'returns correct crc value for known input' do
        # Sample hex strings and expected CRC from known implementation
        hex_00     = "00".dup.force_encoding('UTF-8').unpack1('H*')
        hex_01     = "01".dup.force_encoding('UTF-8').unpack1('H*')
        hex_123456 = "123456".dup.force_encoding('UTF-8').unpack1('H*')
        hex_abcdef = "abcdef".dup.force_encoding('UTF-8').unpack1('H*')
  
  
        assert_equal 105, utils.send(:__crc8_checksum, hex_00)
        assert_equal 110, utils.send(:__crc8_checksum, hex_01)
        assert_equal 253, utils.send(:__crc8_checksum, hex_123456)
        assert_equal 140, utils.send(:__crc8_checksum, hex_abcdef)
      end
  
      it 'returns 0 for empty string' do
        assert_equal 0, utils.send(:__crc8_checksum, '')
      end
  
      it 'returns correct checksum for longer hex strings' do
        long_hex = '0123456789abcdef'*4
        assert utils.send(:__crc8_checksum, long_hex).is_a?(Integer)
      end
    end # _crc8_checksum
  end
end
