# frozen_string_literal: true

##
# EncodedToken::Base
#
# The core configuration settings used for encoding and decoding, along
# with the methods for initialization and verification.
#
# Encoding is achived though a variation of Alberti's cipher for
# multiple Ciphertext Alphabets.
# (https://en.wikipedia.org/wiki/Alberti_cipher
#
class EncodedToken
  module Base

    # ======================================================================
    #  Configuration
    # ======================================================================

    HEX_NUMS         = ('0'..'9').to_a
    HEX_CHARS        = ('a'..'f').to_a + ('A'..'F').to_a
    SPECIAL_CHARS    = ['-']
    HEX_TEXT         = (HEX_NUMS + HEX_CHARS + SPECIAL_CHARS).join # :nodoc:

    CIPHER_CHARS     = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
    CIPHER_TEXT      = CIPHER_CHARS.join # :nodoc:
    CIPHER_COUNT     = 16 # :nodoc:
    TARGET_SIZE      = 55 # :nodoc:

    private_constant :HEX_NUMS, :HEX_CHARS, :SPECIAL_CHARS, :CIPHER_CHARS

    @@seed           = nil
    @@ciphers        = nil
    @@keylist        = nil



    # ======================================================================
    #  Public Methods
    # ======================================================================

    ##
    # Sets the seed to be used in generating a random encoding
    #
    # [returns:]
    #    - true on success
    #
    # [on error:]
    #    - raises an exception
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
    #  Class Private Methods
    # ======================================================================
    private


    # parse the new seed to ensure it is an integer
    #
    # return the Integer seed on success, otherwise raises an error
    #
    def parse_seed(new_seed)
      if valid_integer?(new_seed)
        return new_seed.to_i.abs
      else
        fail_with_invalid_seed_argument
      end
    end



    # Generate a set of ciphers
    #
    # returns - a Hash of ciphers with a CIPHER_CHARS character for each key
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



    # return the next cypher key after the given key, looping to the first when required
    def rotate_cipher_key(key)
      idx             = __keylist.index(key) + 1
      __keylist[idx] || __keylist.first
    end



    #  Validity
    # ======================================================================

    # checks if the seed had been set
    #   - returns true if the seed is set
    #   - set the seed if missing and a valid ENV['ENCODED_TOKEN_SEED'] is present
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



    # check ENV['ENCODED_TOKEN_SEED'] is a string integer
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



    # Return true if the given String only contains hex text
    def valid_hex_text?(val)
      (val.chars - __hex_text.chars).empty?
    end



    # returns true if the given id is is an integer, else false
    #
    # id - and Inetger or String
    #
    def valid_integer?(id)
      sid = id.to_s
      sid.to_i.to_s == sid
    rescue
      false
    end



    # Return true if the given String only contains cipher text text
    def valid_token_text?(val)
      (val.chars - __cipher_text.chars).empty?
    end



    # returns true if the given id is a UUID, else false
    #
    # id - String uuid
    #
    def valid_uuid_format?(id)
      uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
      uuid_regex.match?(id.downcase)
    rescue
      false
    end



    #  Configuration Attributes
    # ======================================================================

    # return the number of ciphers
    def __cipher_count
      CIPHER_COUNT
    end



    # return the cipher keylist
    def __keylist
      @@keylist
    end



    # return the constant cypher text
    def __cipher_text
      CIPHER_TEXT
    end



    # return the base ciphers hash
    def __ciphers
      @@ciphers
    end



    # return the constant hex text
    def __hex_text
      HEX_TEXT
    end



    # return seed
    def __seed
      @@seed
    end



    # return the target size
    def __target_size
      TARGET_SIZE
    end



    #  Error Messages
    # ======================================================================

    # error: invalid ID supplied
    def fail_with_invalid_id_argument
      fail_with ArgumentError,
                ":id must be an Integer, a String integer or a String UUID."
    end



    # error: Seed is already set
    def fail_with_seed_already_set
      fail_with ArgumentError,
                "EncodedToken seed has alreay been set to #{@@seed}."
    end



    # error: invalid Seed supplied
    def fail_with_invalid_seed_argument
      fail_with ArgumentError,
                ":seed must be an Integer, preferably with at least 5 digits."
    end



    # default error message header
    def fail_with(error_klass, message)
      fail error_klass, "\n\nERROR :=> EncodedToken: #{message}\n\n"
    end


  end #module
end #class
