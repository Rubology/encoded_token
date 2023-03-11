# frozen_string_literal: true

class EncodedToken
  ##
  # EncodedToken::Encoder
  #
  #   This module contains the methods for encoding a database record ID (numeric or UUID)
  #   to a web-safe, variable-length String token.
  #
  module Encoder

    #  Public Methods
    # ======================================================================

    ##
    # Generates a web-safe Secure Token from the given ID.
    #
    # @param [Integer, String] id
    #   the record ID (numeric or UUID) to encode.
    #
    # @return [String]
    #   a web-safe, variable length <code>String</code> of alphanumeric characters
    #
    # @raise [RuntimeError]
    #   with an invalid parameter.
    #
    #   Exceptions raised are specific to the failure,
    #   with a backtrace to the failing line of code.
    #
    #   Providing an invalid record ID indicates there is a major problem
    #   with the calling application, so we raise an Exception.
    #
    # @example
    #   EncodedToken.encode!(12345)
    #   #=> "KY3bnaRGmyy6yJS3imWr1dcWtzDYvZjpIAYyCUo5PEKPFvQgtTTed"
    #
    #   EncodedToken.encode!("12345")
    #   #=> "3gDwO7r4UJYeBYDBLU94MqjZQm0SToSE29ACDNcw0xf4QusZKxQHJ"
    #
    #   EncodedToken.encode!("468a5eeb-0cda-4c99-8dba-6a96c33003e0")
    #   #=>  "pAi1SmpKgFAchh76EoLbYLeXVQmLwmMlH2v1zDVeufioKGr0709Qw"
    #
    #   EncodedToken.encode!(:test)
    #   #=>  EncodedToken: :id must be an Integer, a String integer or a String UUID. (RuntimeError)
    #
    def encode!(id)
      assert_valid_seed!
      _assert_valid_id!(id)
      _generate_token(id)
    end



    ##
    # Generates a web-safe Secure Token from the given ID.
    #
    # @param [Integer, String] id
    #   the record ID (numeric or UUID) to encode.
    #
    # @return [String]
    #   a web-safe, variable length <code>String</code> of alphanumeric characters.
    #
    # @raise [ArgumentError]
    #   with an invalid parameter.
    #
    #   Providing an invalid record ID indicates there is a major problem
    #   with the calling application, so we raise an Exception.
    #
    # @example
    #   EncodedToken.encode(12345)
    #   #=> "KY3bnaRGmyy6yJS3imWr1dcWtzDYvZjpIAYyCUo5PEKPFvQgtTTed"
    #
    #   EncodedToken.encode("12345")
    #   #=> "3gDwO7r4UJYeBYDBLU94MqjZQm0SToSE29ACDNcw0xf4QusZKxQHJ"
    #
    #   EncodedToken.encode("468a5eeb-0cda-4c99-8dba-6a96c33003e0")
    #   #=>  "pAi1SmpKgFAchh76EoLbYLeXVQmLwmMlH2v1zDVeufioKGr0709Qw"
    #
    #   EncodedToken.encode(:test)
    #   #=>  EncodedToken: :id must be an Integer, a String integer or a String UUID. (ArgumentError)
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



    ##
    # Ensures the given ID is valid to encode.
    #
    # @param [Integer, String] id
    #   the record ID to encode - max: 255characters - only hex characters + '-'
    #
    # @return [TrueClass, FalseClass]
    #   <code>true</code> if a valid id provided, else <code>false</code>
    #
    # @raise [ArguementError]
    #   if the provided id is invalid
    #
    def _assert_valid_id!(id)
      sid = id.to_s

      fail     if sid.size < 1
      fail     if sid.size > 255
      fail unless valid_hex_text?(sid)
      fail unless valid_integer?(id) || valid_uuid_format?(id)

      return true

    rescue
      fail_with_invalid_id_argument
    end



    ##
    # Generates the encrypted token.
    #
    # @param [Integer, String] id
    #   the record ID to encode.
    #
    # @return [String]
    #   a web-safe, variable-length alphanumeric string.
    #
    # @note
    #   Token composition is [key, id_size, left_padding, enc_id, right_padding].
    #
    def _generate_token(id)
      # stringify the id
      sid = id.to_s

      # select a random cipher key
      token  = key = __keylist.sample

      # _encrypt the id size
      token += _encrypt_size(sid, key)

      # generate the left padding
      token += _random_characters(__ciphers[key][:padding])

      # _encrypt the id
      token += _encrypt(sid, key)

      # generate right padding
      count  = (__target_size - token.size).clamp(0, __target_size)
      token += _random_characters(count)

      # return the new token
      return token
    end



    ##
    # Encrypt the size of the id as a 2-char hex string.
    #
    # @param [String] id
    #   the encrypted record id.
    #
    # @param [Character] key
    #   the starting key for the rotating cypher.
    #
    # @return [String]
    #   a 2-character hexadecimal string.
    #
    # @note
    #   We convert to hex to allow for strings up to 255 chars.
    #
    def _encrypt_size(id, key)
      hex_size = id.size.to_s(16).rjust(2, '0')

      _encrypt(hex_size, key)
    end



    ##
    # Encrypt the id using the cipher text from the given key.
    #
    # @param [String] id
    #   the encrypted record id.
    #
    # @param [Character] key
    #   the starting key for the rotating cypher.
    #
    # @return [String]
    #   the encrypted id.
    #
    # @note
    #   We rotate the cipher every character to avoid sequential values like id: 1000.
    #
    def _encrypt(id, key)
      enc_id       = []
      encipher_key = key

      id.to_s.each_char do |char|
        encipher_key = rotate_cipher_key(encipher_key)
        cipher_text  = __ciphers[encipher_key][:cipher_text]

        enc_id << cipher_text[__hex_text.index(char)]
      end

      return enc_id.join
    end



    ##
    # Generate a String of alphanumeric characters ot the given size.
    #
    # @param [Integer] size
    #   the required number of random characters.
    #
    # @return [String]
    #   a string with the required number of random characters.
    #
    def _random_characters(size)
      SecureRandom.alphanumeric(size)
    end

  end #module
end #class



