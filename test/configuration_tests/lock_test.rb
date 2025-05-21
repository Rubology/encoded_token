
module ConfigurationTests
  class CipherCountTest < MinitestBase
  
    # = Class Methods
    # ======================================================================
  
    describe "Class Method" do
      context ':locked?' do
        
        it 'returns true when the configuration is locked' do
          EncodedToken::Configuration.lock!
          assert EncodedToken::Configuration.locked?
        end
        
        it 'returns false when the configuration is unlocked' do
          EncodedToken::Configuration.unlock!
          refute EncodedToken::Configuration.locked?
        end
      end
      
      context ':unlocked?' do
        it 'returns true when the configuration is unlocked' do
          EncodedToken::Configuration.unlock!
          assert EncodedToken::Configuration.unlocked?
        end
        
        it 'returns false when the configuration is locked' do
          EncodedToken::Configuration.lock!
          refute EncodedToken::Configuration.unlocked?
        end
      end
      
      context ":lock!" do
        it "locks the configuration" do
          EncodedToken::Configuration.unlock!
          
          assert EncodedToken::Configuration.unlocked?
          EncodedToken::Configuration.lock!
          assert EncodedToken::Configuration.locked?
        end
      end
    end
  
    # = Instance Methods
    # ======================================================================
  
    describe "Instance Method" do
      context ':locked?' do
        it 'returns true when the configuration is locked' do
          EncodedToken::Configuration.lock!
          assert EncodedToken::Configuration.instance.locked?
        end
        
        it 'returns false when the configuration is unlocked' do
          EncodedToken::Configuration.unlock!
          refute EncodedToken::Configuration.instance.locked?
        end
      end
      
      context ':unlocked?' do
        it 'returns true when the configuration is unlocked' do
          EncodedToken::Configuration.unlock!
          assert EncodedToken::Configuration.instance.unlocked?
        end
        
        it 'returns false when the configuration is locked' do
          EncodedToken::Configuration.lock!
          refute EncodedToken::Configuration.instance.unlocked?
        end
      end
      
      context ":lock!" do
        it "locks the configuration" do
          EncodedToken::Configuration.unlock!
          assert EncodedToken::Configuration.instance.unlocked?
          EncodedToken::Configuration.instance.lock!
          assert EncodedToken::Configuration.instance.locked?
        end
      end
    end
  end
end
