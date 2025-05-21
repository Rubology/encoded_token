
module EncodedTokenTests
  class GemVersionTest < MinitestBase
  
    describe ':gem_version' do
      it 'returns a Gem::Version object' do
        assert_kind_of Gem::Version, EncodedToken.gem_version
      end
  
      it 'returns the correct version' do
        assert_equal EncodedToken::VERSION::STRING, EncodedToken.gem_version.to_s
      end
    end
  end
end
