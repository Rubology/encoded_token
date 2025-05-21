
module CipherTests
  class ResetTest < MinitestBase
  
    let(:seed)   { 555555 }
    let(:cipher) { EncodedToken::Cipher.new(seed) }
    
    # = :reset!
    # ======================================================================
    
    describe ':reset!' do
      it "resets the cipher rotation back to the root key" do
        root_key = cipher.root_key
        assert_equal root_key, cipher.send(:rotation_key)
        
        5.times { cipher.rotate_keys! }
        refute_equal root_key, cipher.send(:rotation_key)
        
        cipher.reset!
        assert_equal root_key, cipher.send(:rotation_key)
      end
    end
  end
end
