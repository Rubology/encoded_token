# frozen_string_literal: true

require './ruby_version'

task default: :test


desc "Runs the latest tests."
task :test do
  if RubyVersion.latest?
    system "WITH_COVERAGE=true BUNDLE_GEMFILE=#{RubyVersion.gemfile} bundle exec rspec spec"
  else
    system "BUNDLE_GEMFILE=#{RubyVersion.gemfile} bundle exec rspec spec"
  end
end



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
  Rake::Task["test"].invoke

  unless ENV['GITHUB_ACTION']
    `open coverage/index.html`
  end
end



desc "Generates the Yard documentation & opens it in the default browser."
task :doc do
  unless RubyVersion.latest?
    fail "\nDocs only available in Ruby #{RubyVersion.latest_version}\n\n"
  end

  `yardoc`
  `open doc/index.html`
end



desc "Generates the Yard documentation & opens it in the default browser. (alias for :doc)"
task :docs do
  Rake::Task["doc"].invoke
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
