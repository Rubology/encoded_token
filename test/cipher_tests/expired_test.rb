
module CipherTests
  class ExpiredTest < MinitestBase
  
    let(:seed)   { 555555 }
    let(:cipher) { EncodedToken::Cipher.new(seed) }
    
    describe ':expired?' do
      it 'returns false if no expiry date set' do
        cipher = EncodedToken::Cipher.new(555)
        assert_equal false, cipher.expired?
      end
      
      it 'returns false if a future expiry date set' do
        now         = Time.now
        future_time = Time.new(now.year + 1, now.month, now.day)
        cipher = EncodedToken::Cipher.new(555, future_time)
        assert_equal false, cipher.expired?
      end
      
      it 'returns true if a historical expiry date set' do
        now         = Time.now
        passed_time = Time.new(now.year - 1, now.month, now.day)
        cipher = EncodedToken::Cipher.new(555, passed_time)
        assert_equal true, cipher.expired?
      end
    end
  end
end
