# frozen_string_literal: true

class EncodedToken
  ##
  # EncodedToken::Base
  #
  # The core configuration settings used for encoding and decoding, along
  # with the methods for initialization and verification.
  #
  # Encoding is achieved using a variation of Alberti's cipher for
  # multiple Ciphertext Alphabets.
  # (https://en.wikipedia.org/wiki/Alberti_cipher)
  #
  module Base

    # ======================================================================
    #  Public Methods
    # ======================================================================

    ##
    # Sets the seed used to generate random cyphers.
    #
    # @param [Integer, Integer.to_s] new_seed
    #   the seed used for the random number generator when encoding or deconding.
    #
    # @return [TrueClass]
    #   <code>true</code> on success.
    #
    # @raise
    #   an exception on failure.
    #
    def seed=(new_seed)
      if @@seed
        fail_with_seed_already_set
      else
        @@seed = parse_seed(new_seed)
        generate_ciphers
        return true
      end
    end


    # ======================================================================
    #  Class Private
    # ======================================================================
    private


    # ======================================================================
    #  Class Private Configuration
    # ======================================================================

    HEX_NUMS         = ('0'..'9').to_a
    HEX_CHARS        = ('a'..'f').to_a + ('A'..'F').to_a
    SPECIAL_CHARS    = ['-']
    HEX_TEXT         = (HEX_NUMS + HEX_CHARS + SPECIAL_CHARS).join

    CIPHER_CHARS     = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
    CIPHER_TEXT      = CIPHER_CHARS.join
    CIPHER_COUNT     = 16
    TARGET_SIZE      = 55

    @@seed           = nil
    @@ciphers        = nil
    @@keylist        = nil


    # ======================================================================
    #  Class Private Methods
    # ======================================================================

    ##
    # Parses the new seed to ensure it is an Integer.
    #
    # @param [Integer, Integer.to_s] new_seed
    #   the seed to parse.
    #
    # @return [Integer]
    #   the seed converted to a absolute <code>Integer</code>.
    #
    def parse_seed(new_seed)
      if valid_integer?(new_seed)
        return new_seed.to_i.abs
      else
        fail_with_invalid_seed_argument
      end
    end



    ##
    # Generates a random set of ciphers based on the configured seed.
    #
    # @return [Hash]
    #   a <code>Hash</code> of ciphers with a <code>CIPHER_CHARS</code>
    #   character for each key.
    #
    def generate_ciphers
      ciphers = {}
      random  = Random.new(__seed)
      keys    = CIPHER_CHARS.sample(__cipher_count, random: random).sort_by(&:downcase)
      @@keylist = keys

      # for each key, add a hash of the padding chareacter count
      # and a cipher string to be used for encryption, using a different seed each time
      keys.each_with_index do |key, idx|
        ciphers[key] = {
          padding:     random.rand(0..10),
          cipher_text: CIPHER_CHARS.sample(HEX_TEXT.size, random: random).join
        }
      end

      @@ciphers = ciphers
    end



    ##
    # Selects the next cypher key after the given key, looping to the first when required.
    #
    # @param [Character] key
    #   the current cipher key.
    #
    # @return
    #   the next cypher key, looping to the first when required.
    #
    def rotate_cipher_key(key)
      idx             = __keylist.index(key) + 1
      __keylist[idx] || __keylist.first
    end


    #  Validity
    # ======================================================================

    ##
    # Sets the seed from <code>ENV['ENCODED_TOKEN_SEED']</code> if not already set.
    #
    # @return [TrueClass]
    #   <code>true</code> if the seed is set.
    #
    # @raise [RuntimeError]
    #   if the seed is blank and no <code>ENV['ENCODED_TOKEN_SEED']</code> exists.
    #
    def assert_valid_seed!
      case
      when !!@@seed
        true

      when !!ENV['ENCODED_TOKEN_SEED']
        assert_valid_env!
        self.seed = ENV['ENCODED_TOKEN_SEED'].to_i

      else
        fail RuntimeError, "Encryption seed must be set before using EncodedToken."\
                           " Set the seed with EncodedToken.seed=(xxx)."
      end
    end



    ##
    # Asserts that ENV['ENCODED_TOKEN_SEED'] is a string integer.
    #
    # @return [TrueClass]
    #   <code>true</code> if valid.
    #
    # @raise RuntimeError
    #   if <code>ENV['ENCODED_TOKEN_SEED']</code> is not a valid integer.
    #
    def assert_valid_env!
      begin
        if valid_integer?(ENV['ENCODED_TOKEN_SEED'])
          return true
        else
          fail
        end
      rescue
        fail RuntimeError, "ENV['ENCODED_TOKEN_SEED'] must be a string encoded Integer."
      end
    end



    ##
    # Assert the given <code>String</code> only contains hexadecimal characters.
    #
    # @param [String] val
    #   the string to test.
    #
    # @return [TrueClass, FalseClass]
    #   <code>true</code> if a hexidecimal string, otherwise <code>false</code>.
    #
    def valid_hex_text?(val)
      (val.chars - __hex_text.chars).empty?
    end



    ##
    # Asserts the given parameter is an <code>Integer</code> or <code>Integer.to_s</code>.
    #
    # @param [Integer, String] id
    #   the value to test.
    #
    # @return [TrueClass,FalseClass]
    #   <code>true</code> if an integer value, otherwise <code>false</code>.
    #
    # id - and Inetger or String
    #
    def valid_integer?(id)
      sid = id.to_s
      sid.to_i.to_s == sid
    rescue
      false
    end



    ##
    # Assert the given String only contains cipher-text characters.
    #
    # @param [String] val
    #   the <code>String</code> to test.
    #
    # @return
    #   <code>true</code> if the given parameter only contains cipher-text
    #   characters, otherwise <code>false</code>.
    #
    def valid_token_text?(val)
      (val.chars - __cipher_text.chars).empty?
    end



    ##
    # Asserts the given parameter is a UUID.
    #
    # @param [String] id
    #   the UUID to test.
    #
    # @return [TrueClass,FalseClass]
    #   <code>true</code> if the given id is a UUID,
    #   otherwise <code>false</code>.
    #
    def valid_uuid_format?(id)
      uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
      uuid_regex.match?(id.downcase)
    rescue
      false
    end



    #  Configuration Attributes
    # ======================================================================

    ##
    # @return [Integer] the number of ciphers.
    #
    def __cipher_count
      CIPHER_COUNT
    end



    ##
    # @return [Array] the cipher keylist.
    #
    def __keylist
      @@keylist
    end



    ##
    # @return [Array] the constant cypher text.
    #
    def __cipher_text
      CIPHER_TEXT
    end



    ##
    # @return [Hash] the base ciphers.
    #
    def __ciphers
      @@ciphers
    end



    ##
    # @return [String] the constant hex text.
    #
    def __hex_text
      HEX_TEXT
    end



    ##
    # @return [Integer] the configured seed.
    #
    def __seed
      @@seed
    end



    ##
    # @return [Integer] the new token target size.
    #
    def __target_size
      TARGET_SIZE
    end



    #  Error Messages
    # ======================================================================

    ##
    # @raise [ArguementError] for invalid ID arguement.
    #
    def fail_with_invalid_id_argument
      fail_with ArgumentError,
                ":id must be an Integer, a String integer or a String UUID."
    end



    ##
    # @raise [ArguementError] if the seed is already set.
    #
    def fail_with_seed_already_set
      fail_with ArgumentError,
                "EncodedToken seed has alreay been set to #{@@seed}."
    end



    ##
    # @raise [ArguementError] if an invalid seed is supplied.
    #
    def fail_with_invalid_seed_argument
      fail_with ArgumentError,
                ":seed must be an Integer, preferably with at least 5 digits."
    end



    ##
    # Default error message header
    #
    # @param [^Error] error_klass
    #   the error class to fail with.
    #
    # @param [String] message
    #   the error message to fail with.
    #
    # @raise [^Error]
    #   the given error class and message.
    #
    def fail_with(error_klass, message)
      fail error_klass, "\n\nERROR :=> EncodedToken: #{message}\n\n"
    end


  end #module
end #class
