# frozen_string_literal: true

# = Setup: load gems, ignoring any failures when installing
# ======================================================================

# ignore gem requires if bundling
unless Rake.application.top_level_tasks.include?('bundle')
  begin
    require "bundler/setup"
    require "bundler/gem_tasks"
    require "minitest/test_task"
  rescue Bundler::GemNotFound
    puts "\n\nGems not found - run 'rake bundle'\n\n"
  end
end

require "./ruby_version"
ENV["BUNDLE_GEMFILE"] = RubyVersion.gemfile
ENV['RUBYOPT'] = '-W0'


# = define Minitest :test task
# ======================================================================

# if Minitest gem is installed
if defined?(Minitest)
  Minitest::TestTask.create(:test) do |t|
    t.warning = false
    t.test_globs = ["test/**/*_test.rb"]
    t.test_prelude = %(require File.expand_path("test/test_helper", Dir.pwd))
  end
end
task default: :test

# = install gems
# ======================================================================

desc "Installs gems using the correct gemfile for the current version of ruby."
task :bundle do
  puts "Installing from '#{RubyVersion.gemfile}'"
  system("bundle install --gemfile=#{RubyVersion.gemfile}")
  system("bundle lock --add-platform x86_64-linux --gemfile=#{RubyVersion.gemfile}")
end


# = Show outdated gems
# ======================================================================

desc "Runs bundle outdated for the current version of ruby."
task :outdated do
  puts "Checking outdated for '#{RubyVersion.gemfile}'"
  system("BUNDLE_GEMFILE=#{RubyVersion.gemfile} bundle outdated")
end



# = Update current gems
# ======================================================================

desc "Runs bundle update for the current version of ruby."
task :update do
  puts "Updating for '#{RubyVersion.gemfile}'"
  system("BUNDLE_GEMFILE=#{RubyVersion.gemfile} bundle update")
end



# = Open the coverage report
# ======================================================================

desc "Opens the coverage results in the default browser."
task :coverage do
  ENV["WITH_COVERAGE"] = 'true'
  
  Rake::Task["test"].invoke rescue nil

  unless ENV['GITHUB_ACTION']
    `open coverage/index.html`
  end
end



# = Generate Yard Documentation
# ======================================================================

desc "Generates the Yard documentation & opens it in the default browser."
task :doc do
  unless RubyVersion.latest?
    fail "\nDocs only available in Ruby #{RubyVersion.latest_version}\n\n"
  end

  `yardoc`
  `open doc/index.html`
end



# = Generate Yard Documentation and open in browser
# ======================================================================

desc "Generates the Yard documentation & opens it in the default browser. (alias for :doc)"
task :docs do
  Rake::Task["doc"].invoke
end



# = Run Rubocop
# ======================================================================

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
