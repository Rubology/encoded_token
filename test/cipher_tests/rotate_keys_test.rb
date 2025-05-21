
module CipherTests
  class RotateKeysTest < MinitestBase
  
    let(:seed)   { 555555 }
    let(:cipher) { EncodedToken::Cipher.new(seed) }
    
    # = :rotate_keys!
    # ======================================================================
    
    describe ':rotate_keys!' do
      context "on success" do
        context "without a target key" do
          it "rotates the cipher to the next key in the list" do
            key_list        = cipher.send(:keys)
            cipher.root_key = key_list.first
            
            assert_equal key_list.first, cipher.send(:rotation_key)
            
            5.times do |idx|
              cipher.rotate_keys!
              assert_equal key_list[idx + 1], cipher.send(:rotation_key)
            end
          end
        end
        
        context "with a target key" do
          it "rotates the cipher to the target key" do
            5.times do
              target_key = cipher.send(:keys).sample
              cipher.rotate_keys!(target_key: target_key)
              assert_equal target_key, cipher.send(:rotation_key)
            end
          end
        end
      end # on success
      
      
      context "on failure" do
        it "fails with a key not in the key-list" do
          cipher.stubs(:valid_key?).returns(false)
          assert_raises *error_for(:invalid_root_key) do
            cipher.rotate_keys!(target_key: 'a')
          end
        end
      end
    end
  end
end
