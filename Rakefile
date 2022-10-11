# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require './ruby_version'


RSpec::Core::RakeTask.new(:spec)

task default: :spec


desc "Bundles the correct gemfile for the current version of ruby."
task :bundle do
  puts "Bundling '#{RubyVersion.gemfile}'"
  system("bundle --gemfile=#{RubyVersion.gemfile}")
  system("bundle lock --add-platform x86_64-linux --gemfile=#{RubyVersion.gemfile}")
end



desc "Opens the coverage results in the default browser."
task :coverage do
  ENV["COVERAGE"] = 'true'
  Rake::Task[:spec].invoke

  unless ENV['FOR_TESTSPACE']
    `open coverage/index.html`
  end
end



desc "Generates the Sdoc files & opens them in the default browser."
task :doc do
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
  `rackup doc_server.ru`
end



desc "Runs 'rubocop' on the 'lib' directory, auto-correcting appropved cops."
task :rubo do
  corrections = [
                  'Layout/TrailingWhitespace',
                  'Layout/EmptyLinesAroundClassBody',
                  'Layout/EmptyLinesAroundModuleBody',
                  'Layout/EmptyLineBetweenDefs'
                ]
  system "bundle exec rubocop --autocorrect --only #{corrections.join(',')} lib/"
end




