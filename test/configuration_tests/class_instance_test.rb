
module ConfigurationTests
  class ClassInstanceTest < MinitestBase
  
    describe ':instance' do
      it 'returns the same instance no matter how may times called' do
        instance = EncodedToken::Configuration.instance
        100.times do
          assert_equal instance.object_id, EncodedToken::Configuration.instance.object_id
        end
      end
    end
  end
end
