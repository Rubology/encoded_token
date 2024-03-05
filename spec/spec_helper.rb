# frozen_string_literal: true

require './ruby_version'

#  Coverage
# ======================================================================

# Only calculate coverage when requested
if ENV['WITH_COVERAGE']
  puts "\nCoverage requested."
  begin
    require 'simplecov'

    SimpleCov.configure do
      # exclude tests
      add_filter 'spec'
    end

    # if ENV['FAIL_ON_MINIMUM']
    #   SimpleCov.minimum_coverage 100
    # end

    # start it up
    SimpleCov.start

  rescue LoadError
    puts "\n *** Coverage required, but SimpleCov gem not available! ***"

  ensure
    # clear the WITH_COVERAGE environmental variable
    ENV.delete 'WITH_COVERAGE'
  end
end



#  EncodedToken
# ======================================================================

require "encoded_token"



#  Debug
# ======================================================================

# Only add 'debug' if latest version of Ruby
if RubyVersion.latest?
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
