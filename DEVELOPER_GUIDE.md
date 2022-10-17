# Developer Guide

## Setup

1. [Fork the project](https://help.github.com/articles/about-forks/)
2. Clone your new fork: `git clone git@github.com:[USERNAME]/encoded_token.git`
3. Change your working directory: `cd encoded_token`
4. Change to the most recent version of Ruby
5. Install the most recent Bundler: `gem install bundler`
6. Install the most recent Rake: `gem install rake`
7. Install the gems: `rake install`
8. Ensure all the tests are passing: `rake`



## Adding a New Feature

1. Create your feature branch `git checkout -b new-feature-branch`
2. Write tests for your new feature
3. Write your feature code
4. Run the tests: `rake`
5. Check your new code is 100% tested: `rake coverage`
6. Check your coding style passes: `rake rubo`
7. Start the doc server: `rake doc_server`
8. Check your documentation reads well: `rake docs`
9. Check that all the test pass with the latest version of Ruby
10. Check that all the test pass with each minor version of Ruby from 2.5 up
11. Commit your changes `git commit -am 'My New Feature'`



## Sending the Changes

1. Push the new branch to GitHub `git push origin new-feature-branch`
2. Create a new [Pull Request](https://help.github.com/articles/creating-a-pull-request/)



## GEMS

We test with every minor version of Ruby from 2.5 onwards. As some gems are only
available for certain Ruby versions, we need to use seperate Gemfiles for each version.

The task `rake install` automatically selects the correct gemfile to use and runs `bundle install`.
It also adds the `x86_64-linux` platform to the lockfile.

The task `rake outdated` automatically selects the correct gemfile to use and runs `bundle outdated` 

The task `rake update` automatically selects the correct gemfile to use and runs `bundle update` 

**Note**: Development gems are only available in the latest version of Ruby.


## Coverage

We use [SimpleCov](https://github.com/simplecov-ruby/simplecov) to ensure
test coverage for every line of code. Ensure your test coverage is at 100%
before submitting a Pull request.

The coverage report can be generated and opened with: `rake coverage`



## SDoc

We use [SDoc](https://github.com/zzak/sdoc) to produce the documentation.
Ensure your method comments match the existing style.

Documentation can be generated and opened with: `rake docs`

Note: a simple rack server is required for SDoc documentation. Start it with `rake doc_server`



## RuboCop

We use [RuboCop](https://rubocop.org) to enforce a consistent style
in the codebase. Reading through the exisitng code first is a great way to
get started.

Cops can be run with: `rake rubo`




## Rake Tasks

> Run test.

`rake`


> Run test coverage and open report.

`rake coverage`


> Generate documentation and open in browser.

`rake doc`


> Run RuboCop.

`rake rubo`



