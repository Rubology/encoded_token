# frozen_string_literal: true

require "rspec/core/rake_task"
require './ruby_version'


RSpec::Core::RakeTask.new(:spec)

task default: :spec


desc "Installs gems using the correct gemfile for the current version of ruby."
task :install do
  puts "Installing from '#{RubyVersion.gemfile}'"
  system("bundle --gemfile=#{RubyVersion.gemfile}")
  system("bundle lock --add-platform x86_64-linux --gemfile=#{RubyVersion.gemfile}")
end



desc "Runs bundle outdated for the current version of ruby."
task :outdated do
  puts "Checking outdated for '#{RubyVersion.gemfile}'"
  system("BUNDLE_GEMFILE=#{RubyVersion.gemfile} bundle outdated")
end



desc "Runs bundle update for the current version of ruby."
task :update do
  puts "Updating for '#{RubyVersion.gemfile}'"
  system("BUNDLE_GEMFILE=#{RubyVersion.gemfile} bundle update")
end



desc "Opens the coverage results in the default browser."
task :coverage do
  unless RubyVersion.latest?
    fail "\nCoverage only available in Ruby #{RubyVersion.latest_version}\n\n"
  end

  ENV["COVERAGE"] = 'true'
  Rake::Task[:spec].invoke

  unless ENV['FOR_TESTSPACE']
    `open coverage/index.html`
  end
end



desc "Generates the Sdoc files & opens them in the default browser."
task :doc do
  unless RubyVersion.latest?
    fail "\nDocs only available in Ruby #{RubyVersion.latest_version}\n\n"
  end

  `sdoc -e "UTF-8" --title 'EncodedToken' --main README.md -T 'rails' -x 'encoded_token/rspec/*' README.md CODE_OF_CONDUCT.md DEVELOPER_GUIDE.md EXAMPLE.md lib`
  # `open doc/index.html`
  `open http://localhost:9292`
end



desc "Generates the Sdoc files & opens them in the default browser. (alias for :doc)"
task :docs do
  Rake::Task["doc"].invoke
end



desc "starts a rackup server for the docs."
task :doc_server do
  unless RubyVersion.latest?
    fail "\nDoc Server only available in Ruby #{RubyVersion.latest_version}\n\n"
  end

  `rackup doc_server.ru`
end



desc "Runs 'rubocop' on the 'lib' directory, auto-correcting appropved cops."
task :rubo do
  unless RubyVersion.latest?
    fail "\nRubocop only available in Ruby #{RubyVersion.latest_version}\n\n"
  end

  corrections = [
                  'Layout/TrailingWhitespace',
                  'Layout/EmptyLinesAroundClassBody',
                  'Layout/EmptyLinesAroundModuleBody',
                  'Layout/EmptyLineBetweenDefs'
                ]
  system "BUNDLE_GEMFILE=#{RubyVersion.gemfile} bundle exec rubocop --autocorrect --only #{corrections.join(',')} lib/"
end




