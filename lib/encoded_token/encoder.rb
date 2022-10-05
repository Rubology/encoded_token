# frozen_string_literal: true

##
# EncodedToken::Encoder
#
# The methods required to encode a token with an Integer ID or String UUID.
#
class EncodedToken # :nodoc:
  module Encoder

    #  Public Methods
    # ======================================================================

    ##
    # Generates a Secure Token from the given ID
    #
    # [args:]
    #   - *id* [Integer, String] - the ID or UUID to encode
    #   - eg. 12345, "12345", "468a5eeb-0cda-4c99-8dba-6a96c33003e0"
    #
    # [returns:]
    #   - a web-safe, variable length String of alphanumeric characters
    #
    # [on error:]
    #   - raises an exception based on the error
    #
    # *examples:*
    #
    #   EncodedToken.encode!(12345)
    #   # => "KY3bnaRGmyy6yJS3imWr1dcWtzDYvZjpIAYyCUo5PEKPFvQgtTTed"
    #
    #   EncodedToken.encode!("12345")
    #   # => "3gDwO7r4UJYeBYDBLU94MqjZQm0SToSE29ACDNcw0xf4QusZKxQHJ"
    #
    #   EncodedToken.encode!("468a5eeb-0cda-4c99-8dba-6a96c33003e0")
    #   # =>  "pAi1SmpKgFAchh76EoLbYLeXVQmLwmMlH2v1zDVeufioKGr0709Qw"
    #
    #   EncodedToken.encode!(:test)
    #   # =>  EncodedToken: :id must be an Integer, a String integer or a String UUID. (RuntimeError)
    #
    def encode!(id)
      assert_valid_seed!
      assert_valid_id!(id)
      generate_token(id)
    end



    ##
    # Generates a Secure Token from the given ID
    #
    # [args:]
    #   - *id* [Integer, String] - the ID or UUID to encode
    #     - eg. 12345, "12345", "468a5eeb-0cda-4c99-8dba-6a96c33003e0"
    #
    # [returns:]
    #   - a web-safe, variable length String of alphanumeric characters
    #
    # [on error:]
    #   - raises an ArgumentError
    #
    # *examples:*
    #
    #   EncodedToken.encode(12345)
    #   # => "KY3bnaRGmyy6yJS3imWr1dcWtzDYvZjpIAYyCUo5PEKPFvQgtTTed"
    #
    #   EncodedToken.encode("12345")
    #   # => "3gDwO7r4UJYeBYDBLU94MqjZQm0SToSE29ACDNcw0xf4QusZKxQHJ"
    #
    #   EncodedToken.encode("468a5eeb-0cda-4c99-8dba-6a96c33003e0")
    #   # =>  "pAi1SmpKgFAchh76EoLbYLeXVQmLwmMlH2v1zDVeufioKGr0709Qw"
    #
    #   EncodedToken.encode(:test)
    #   # =>  EncodedToken: :id must be an Integer, a String integer or a String UUID. (RuntimeError)
    #
    #
    def encode(id)
      encode!(id)
    rescue ArgumentError
      fail_with_invalid_id_argument
    end



    # ======================================================================
    #  Class Private Methods
    # ======================================================================
    #
    private



    # ensures the given ID is valid to encode
    #
    # id - an Integer, numerical String integer or UUID
    #    - max size of 255 characters
    #    - contain only hex charatacters + '-'
    #
    # returns - true if valid
    #
    # on error: - an ArgumentError is raised
    #
    def assert_valid_id!(id)
      sid = id.to_s

      fail     if sid.size < 1
      fail     if sid.size > 255
      fail unless valid_hex_text?(sid)
      fail unless valid_integer?(id) || valid_uuid_format?(id)

      return true

    rescue
      fail_with_invalid_id_argument
    end



    # generates the token
    #
    # id - Integer, String integer or String UUID
    #
    # returns - an alphanumeric String token
    #
    # Note - token comprises [key, id_size, left_padding, enc_id, right_padding]
    #
    def generate_token(id)
      # stringify the id
      sid = id.to_s

      # select a random cipher key
      token  = key = __keylist.sample

      # encrypt the id size
      token += encrypt_size(sid, key)

      # generate the left padding
      token += random_characters(__ciphers[key][:padding])

      # encrypt the id
      token += encrypt(sid, key)

      # generate right padding
      count  = (__target_size - token.size).clamp(0, __target_size)
      token += random_characters(count)

      # return the new token
      return token
    end



    # return the encrypted size of the id
    #
    # returns a 2-character String
    #
    # note - we convert to hex to allow for strings up to 255 chars
    #
    def encrypt_size(id, key)
      hex_size = id.size.to_s(16).rjust(2, '0')

      encrypt(hex_size, key)
    end



    # encrypt the id using the cipher text from the given key.
    # - rotate the cipher every character to avoid sequential valuies like id: 1000
    #
    def encrypt(id, key)
      enc_id       = []
      encipher_key = key

      id.to_s.each_char do |char|
        encipher_key = rotate_cipher_key(encipher_key)
        cipher_text  = __ciphers[encipher_key][:cipher_text]

        enc_id << cipher_text[__hex_text.index(char)]
      end

      return enc_id.join
    end



    # generate a String of alphanumeric characters ot the given size
    #
    def random_characters(size)
      SecureRandom.alphanumeric(size)
    end

  end #module
end #class



