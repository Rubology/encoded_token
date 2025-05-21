
require "minitest"

# ======================================================================
# = Header
# ======================================================================

##
# Don't show if testing via RubyMine
#
unless ENV['RM_INFO'] || ENV['TEAMCITY_VERSION']
  puts "\n\nTestings with:"
  puts " - Ruby: #{RUBY_VERSION}"
  puts " - Gemfile: #{ENV['BUNDLE_GEMFILE']}"
  puts " - Minitest: #{Minitest::VERSION}\n\n"
end


# ======================================================================
# = SimpleCov
# ======================================================================

# Only calculate coverage when requested
if ENV['WITH_COVERAGE']
  puts "\nCoverage requested."
  begin
    require 'simplecov'

    SimpleCov.configure do
      # exclude tests
      add_filter 'test'
      add_filter 'version.rb'
      add_filter 'ruby_version.rb'
      
      # explicitly track lib files
      track_files 'lib/**/*.rb'
    end

    # set auto-fail is less than 100% coverage
    SimpleCov.minimum_coverage(100) if ENV['FAIL_ON_MINIMUM']
    
    # start it up
    SimpleCov.start

  rescue LoadError
    puts "\n *** Coverage required, but SimpleCov gem not available! ***"

  ensure
    # clear the WITH_COVERAGE environmental variable
    ENV.delete 'WITH_COVERAGE'
  end
end


# ======================================================================
# = Test Helper
# ======================================================================

require "minitest/autorun"
require "minitest/spec"
require 'mocha/minitest'
require File.expand_path("./minitest_base", __dir__)
require 'securerandom'

# debug in ruby 2 goes straight to the debug console
require 'ruby_version'
require 'debug' if RubyVersion >= 3.0

# require AFTER simpleCov has started to ensure inclusion in metrics
require File.expand_path("../lib/encoded_token", __dir__)
