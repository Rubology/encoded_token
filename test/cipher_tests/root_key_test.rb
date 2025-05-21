
module CipherTests
  class RootKeyTest < MinitestBase
  
    let(:seed)   { 555555 }
    let(:cipher) { EncodedToken::Cipher.new(seed) }
    
    # = :root_key
    # ======================================================================
    
    describe ':root_key' do
      it "returns the cipher's root key" do
        new_root = cipher.send(:keys).sample
        cipher.root_key = new_root
        
        assert_equal new_root, cipher.root_key
      end
    end
    
    
    # = :root_key=
    # ======================================================================
    
    describe ':root_key=' do
      context 'on success' do
        it 'sets the root key used for the cipher' do
          new_root = cipher.send(:keys).sample
          cipher.root_key = new_root
          
          assert_equal new_root, cipher.root_key
        end
        
        it "resets the cipher to the new root key" do
          cipher.stubs(:valid_key?).returns(true)
          cipher.expects(:reset!).once.returns(true)
          
          cipher.root_key = 'a'
        end
      end # on success
      
      context "on failure" do
        it "fails with a key not in the key-list" do
          cipher.stubs(:valid_key?).returns(false)
          assert_raises *error_for(:invalid_root_key) do
            cipher.root_key = 'invalid'
          end
        end
      end
    end
  end
end
