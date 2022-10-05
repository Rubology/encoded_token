# frozen_string_literal: true

##
# EncodedToken::Encoder
#
# The methods required to decode a token.
#
class EncodedToken # :nodoc:
  module Decoder

    # ======================================================================
    #  Public Methods
    # ======================================================================

    ##
    # Decode a previously encoded token to return the original ID
    #
    # [args:]
    #   - *token* [String]
    #
    # [returns:]
    #   - a String with the original ID
    #
    # [on error:]
    #   - an invalid String token returns +nil+
    #   - otherwise an exception will be raised
    #
    # *examples:*
    #
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
    # Decode a previously encoded token to return the original ID
    #
    # [args:]
    #   - *token* [String]
    #
    # [returns:]
    #   - a String with the original ID
    #
    # [on error:]
    #   - returns +nil+
    #
    # *examples:*
    #
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


    # ensures the given token is valid to decode
    #
    # token [String] - a properly encoded String
    #
    # returns - a String duplicate of the given token
    #
    # on error: - a RuntimeError is raised
    #
    # NOTE: - we return a duplicate so the original is not changed later
    #         in the process when shifting segments
    #
    def sanitize_token(token)
      fail 'Token is not a string.'   unless token.is_a?(String)
      fail 'Invalid token characters' unless valid_token_text?(token)
      fail 'Invalid token cipher.'    unless __keylist.include?(token[0])
      token.dup
    end



    # Parses the token to retrieve the original ID
    #
    # token [String] - the encoded token
    #
    # returns [String] - the original ID
    #
    def parse_token(token)
      key      = token[0]
      id_size  = decrypt_size(token[1,2], key)
      padding  = __ciphers[key][:padding]
      enc_id   = token[padding + 3, id_size]

      return decrypt(enc_id, key)
    end



    # returns the Integer size of the id
    #
    # enc_size - the encrypted ID
    # key      - the cipher key to use
    #
    def decrypt_size(enc_size, key)
      decrypt(enc_size, key).hex
    end



    # decrypt the id using the cipher text from the given key.
    # - rotate the cipher every character
    #
    # enc_id - encoded String ID
    # key    - base cipher key to use
    #
    # on error - rasies an exception (invalid cipher chars, etc)
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

