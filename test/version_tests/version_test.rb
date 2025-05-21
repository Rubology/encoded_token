
module VersionTests
  class VersionTest < MinitestBase
  
    describe ':version' do
      it 'returns the correct version string' do
        assert_equal "2.0.0", EncodedToken::VERSION::STRING
      end
      
      it 'returns the correct GemVersion object' do
        computed_version = Gem::Version.new EncodedToken::VERSION::STRING
        assert_equal computed_version, EncodedToken.gem_version
      end
    end
  end
end
