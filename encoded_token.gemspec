# frozen_string_literal: true

require_relative "lib/encoded_token/version"

Gem::Specification.new do |spec|
  spec.name    = "encoded_token"
  spec.version = EncodedToken.gem_version
  
  spec.author  = 'CodeMeister'
  spec.email   = 'encoded_token@codemeister.dev'
  
  spec.summary     = "A better, more secure and efficient way to manage secure-tokens - by encoding the ID"\
                     ", or UUID, within the token itself."

  spec.description = "Stop hitting the DB with every secure-token submission."\
                     " Encoded Tokens have the ID, or UUID, encoded within the token itself -"\
                     " increasing both security and performance. Coded in plain Ruby,"\
                     " EncodedToken is framework agnostic."
  
  spec.homepage    = 'https://github.com/Rubology/encoded_token'
  spec.license     = 'MIT'
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = 'https://github.com/Rubology/encoded_token'
  spec.metadata["changelog_uri"]   = 'https://github.com/Rubology/encoded_token/blob/master/CHANGELOG.md'

  spec.files         = Dir.glob('lib/**/*', File::FNM_DOTMATCH)
  spec.require_paths = ["lib"]
end
