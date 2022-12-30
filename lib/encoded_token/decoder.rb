# frozen_string_literal: true

class EncodedToken
  ##
  # EncodedToken::Encoder
  #
  # This module contains the methods for decoding a token.
  #
  module Decoder

    # ======================================================================
    #  Public Methods
    # ======================================================================

    ##
    # Decodes a previously encoded token to return the original ID.
    #
    # @param [String] token
    #   a previously encoded token.
    #
    # @return [String]
    #   the original record ID.
    #
    # @raise [RuntimeError]
    #   with an invalid parameter.
    #
    # @example
    #   EncodedToken.decode!("KY3bnaRGmyy6yJS3imWr1dcWtzDYvZjpIAYyCUo5PEKPFvQgtTTed")
    #   #=> "12345"
    #
    #   EncodedToken.decode!("3gDwO7r4UJYeBYDBLU94MqjZQm0SToSE29ACDNcw0xf4QusZKxQHJ")
    #   #=> "12345"
    #
    #   EncodedToken.decode!("pAi1SmpKgFAchh76EoLbYLeXVQmLwmMlH2v1zDVeufioKGr0709Qw")
    #   #=> "468a5eeb-0cda-4c99-8dba-6a96c33003e0"
    #
    #   EncodedToken.decode!("abcdefghijklmnopqrstuvwxyz")
    #   #=> nil
    #
    #   EncodedToken.decode!(:test)
    #   #=> Token is not a string. (RuntimeError)
    #
    def decode!(token)
      assert_valid_seed!

      token = sanitize_token(token)
      id    = parse_token(token)

      # is it a UUID or numeric ID
      if valid_integer?(id) || valid_uuid_format?(id)
        return id
      else
        return nil
      end
    end



    ##
    # Decodes a previously encoded token to return the original ID.
    #
    # @param [String] token
    #   a previously encoded token.
    #
    # @return [String, NilClass]
    #   the original record ID if valid, otherwise <code>nil</code>.
    #
    # @example
    #   EncodedToken.decode("KY3bnaRGmyy6yJS3imWr1dcWtzDYvZjpIAYyCUo5PEKPFvQgtTTed")
    #   #=> "12345"
    #
    #   EncodedToken.decode("3gDwO7r4UJYeBYDBLU94MqjZQm0SToSE29ACDNcw0xf4QusZKxQHJ")
    #   #=> "12345"
    #
    #   EncodedToken.decode("pAi1SmpKgFAchh76EoLbYLeXVQmLwmMlH2v1zDVeufioKGr0709Qw")
    #   #=> "4ef2091f-023b-4af6-9e9f-f46465f897ba"
    #
    #   EncodedToken.decode("abcdefghijklmnopqrstuvwxyz")
    #   #=> nil
    #
    #   EncodedToken.decode(:test)
    #   #=> nil
    #
    def decode(id)
      decode!(id)
    rescue
      nil
    end


    # ======================================================================
    #  Private Methods
    # ======================================================================
    #
    private


    ##
    # Ensures the given token is valid to decode.
    #
    # @param [String] token
    #   a properly encoded <code>String</code>.
    #
    # @return [String]
    #   a <code>String</code> duplicate of the given token.
    #
    # @raise [RuntimeError]
    #   on error.
    #
    # @note
    #   We return a duplicate so the original is not changed later
    #   in the process when shifting segments.
    #
    def sanitize_token(token)
      fail 'Token is not a string.'   unless token.is_a?(String)
      fail 'Invalid token characters' unless valid_token_text?(token)
      fail 'Invalid token cipher.'    unless __keylist.include?(token[0])
      token.dup
    end



    ##
    # Parses the token to retrieve the original ID.
    #
    # @param [String] token
    #   the encoded tokevln.
    #
    # @return [String]
    #   the original ID.
    #
    def parse_token(token)
      key      = token[0]
      id_size  = decrypt_size(token[1,2], key)
      padding  = __ciphers[key][:padding]
      enc_id   = token[padding + 3, id_size]

      return decrypt(enc_id, key)
    end



    ##
    # Returns the Integer size of the id.
    #
    # @param [String] enc_size
    #   the encrypted ID.
    #
    # @param [Character] key
    #   the cipher key to use.
    #
    def decrypt_size(enc_size, key)
      decrypt(enc_size, key).hex
    end



    ##
    # Decrypts the id using the cipher text from the given key.
    #
    # @param [String] enc_id
    #   the encoded ID.
    #
    # @param [Character] key
    #   the base cipher key to use.
    #
    # @return [String]
    #   the original record ID.
    #
    # @raise
    #   an exception on any error, such as invalid cipher chars, etc.
    #
    # @note
    #   The cipher is rotated with every character.
    #
    def decrypt(enc_id, key)
      id      = ""
      enc_key = key

      enc_id.each_char do |char|
        enc_key     = rotate_cipher_key(enc_key)
        cipher_text = __ciphers[enc_key][:cipher_text]

        id += __hex_text[cipher_text.index(char)]
      end

      return id
    rescue
      fail 'Invalid token characters'
    end

  end #module
end #class

