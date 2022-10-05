# frozen_string_literal: true

#  Coverage
# ======================================================================

# Only calculate coverage if requested
if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  
  SimpleCov.configure do
    # exclude tests
    add_filter 'spec'
  end
  
  # set output to Coberatura XML if using Testspace analysis
  if ENV['FOR_TESTSPACE']
    require 'simplecov-cobertura'
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end
  
  # start it up
  SimpleCov.start
end



#  EncodedToken
# ======================================================================

require "encoded_token"



#  Debug
# ======================================================================

# Only add 'debug' if Ruby 3.1 or higher
if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1')
  require "debug"
end



# ======================================================================
#  RSPec config
# ======================================================================

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


# ======================================================================
#  Helpers
# ======================================================================

def capture_stdout(&blk)
  old = $stdout
  $stdout = fake = StringIO.new
  yield
  fake.string
ensure
  $stdout = old
end


def capture_stderr(&blk)
  old = $stderr
  $stderr = fake = StringIO.new
  yield
  fake.string
ensure
  $stderr = old
end
