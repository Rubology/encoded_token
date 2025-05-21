
class MinitestBase < Minitest::Test

  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)
  
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  
  # Enable spec-style DSL
  extend Minitest::Spec::DSL
  
  class << self
    alias context describe
  end
  
  def error_for(key)
    [EncodedToken::ErrorMessages::ERROR_MESSAGES[key][:error_klass],
     EncodedToken::ErrorMessages::ERROR_MESSAGES[key][:message]]
  end
  
  
  def reset_configuration!
    [ EncodedToken, EncodedToken::Configuration, EncodedToken::Encoder].each do |mod|
      mod.instance_variables.each { |ivar| mod.remove_instance_variable(ivar) }
    end
  end
  
  def refresh_configuration!
    reset_configuration!
    EncodedToken::Configuration.instance.seed = 555555
    EncodedToken::Encoder.build_ciphers!
  end
end
