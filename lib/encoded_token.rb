# frozen_string_literal: true

require          "date"
require          "securerandom"
require_relative "encoded_token/error_messages.rb"
require_relative "encoded_token/cipher.rb"
require_relative "encoded_token/utils.rb"
require_relative "encoded_token/configuration.rb"
require_relative "encoded_token/encryptor.rb"
require_relative "encoded_token/encoder"
require_relative "encoded_token/encoder/legacy_encoder.rb"
require_relative "encoded_token/encoder/legacy_decoder.rb"
require_relative "encoded_token/encoder/utf8_encoder.rb"
require_relative "encoded_token/encoder/utf8_decoder.rb"
require_relative "encoded_token/version.rb"

##
# = EncodedToken
#
# Encodes a UTF-8 String to produce a Secure Token,
# then decodes the Secure Token to return the original input.
#
# - The given input is encoded using a substitution cipher, then padded
#   with alphanumeric characters to a random length.
#
# - Multiple substitution ciphers are used to improve security.
#
# *examples:*
#
#   EncodedToken.encode(12345)
#   # => "b4ex6AEB62jlBGpVAGNou8iRmD7pnHGHafQlAHB7w0J"
#
#   EncodedToken.decode("b4ex6AEB62jlBGpVAGNou8iRmD7pnHGHafQlAHB7w0J")
#   # => "12345"
#
module EncodedToken
  
  # ======================================================================
  # = Macros
  # ======================================================================
  
  extend ErrorMessages

  # ======================================================================
  # = Class Methods
  # ======================================================================
  
  class << self

    ##
    # Returns the configuration instance.
    #
    # @return [Configuration]
    #   a memoized instance of the Configuration class.
    #
    def configuration
      @configuration ||= Configuration.instance
    end

    ##
    # Applies the provided block to the configuration and builds the ciphers.
    #
    # @yield [block]
    #   a configuration block
    #
    # @return [void]
    #
    # @example
    #   EncodedToken.configure do |config|
    #     config.seed = 12345
    #   end
    #
    def configure
      yield(configuration)

      Encoder.build_ciphers!
    end

    ##
    # Encodes a given input to an encoded token.
    #
    # @param [Integer, String, *.to_s] input
    #   any object that responds to '.to_s'
    # @param [:utf8, :legacy] encoder
    #   the encoder to use.
    #
    # @return [String] if successful
    # @return [nil]    if unsuccessful
    #
    def encode(input, encoder = :utf8)
      Encoder.encode(input, encoder)
    end

    ##
    # Encodes a given input to an encoded token, raising an exception
    # if encountered
    #
    # @param [Integer, String, *.to_s] input
    #   any object that responds to '.to_s'
    # @param [:utf8, :legacy] encoder
    #   the encoding to use.
    #
    # @return [String] the encoded token
    #
    # @raise [ArgumentError, RuntimeError]
    #   if the encoding fails
    #
    def encode!(input, encoder = :utf8)
      Encoder.encode!(input, encoder)
    end

    
    ##
    # Decodes a given token to the original string
    #
    # @param [String] token
    #   an encoded-token string
    #
    # @return [String]
    #   the decoded value if successful
    # @return [nil]
    #   if unsuccessful
    #
    def decode(token)
      Encoder.decode(token)
    end

    
    ##
    # Decodes a given token to the original string, raising an exception
    # if encountered
    #
    # @param [String] token
    #   an encoded-token string
    #
    # @return [String]
    #   the decoded value
    #
    # @raise [ArgumentError, RuntimeError]
    #   if the decoding fails
    #
    def decode!(token)
      Encoder.decode!(token)
    end
  end # class << self
end #module
