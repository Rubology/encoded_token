# frozen_string_literal: true

##
# = EncodedToken
#
# Encodes a UUID or numeric ID to produce a Secure Token,
# then decodes the Secure Token to return the origianl ID.
#
# - The given ID is encoded using a substitution cipher, then padded
#   with alphanumeric characters to a random length.
#
# - Multiple substituion ciphers are used to improve security.
#
# *examples:*
#
#   EncodedToken.encode(12345)
#   # => "b4ex6AEB62jlBGpVAGNou8iRmD7pnHGHafQlAHB7w0J"
#
#   EncodedToken.decode("b4ex6AEB62jlBGpVAGNou8iRmD7pnHGHafQlAHB7w0J")
#   # => "12345"
#
class EncodedToken


  # ======================================================================
  #  Macros
  # ======================================================================

  require            "securerandom"
  require_relative   "encoded_token/base.rb"
  require_relative   "encoded_token/encoder.rb"
  require_relative   "encoded_token/decoder.rb"

  extend EncodedToken::Base
  extend EncodedToken::Encoder
  extend EncodedToken::Decoder


  # ======================================================================
  #  Public Instance Methods
  # ======================================================================

  # This is an abstract class, so ensure no instantiation
  def initialize # :nodoc:
    raise NotImplementedError.new("SecureToken is an abstract class and cannot be instantiated.")
  end

end #class
