# frozen_string_literal: true

module EncodedToken
  ##
  # EncodedToken::Utils
  #
  #   This module contains look-up and validation functions.
  #
  module Utils

    # ======================================================================
    # = Private Instance Methods
    # ======================================================================
    #
    private

    ##
    # Generates a random alphanumeric string of the given size.
    #
    # @param [Integer] size
    #
    # @return [String]
    #
    def random_characters(size)
      SecureRandom.alphanumeric(size)
    end

    ##
    # Generates a random hex string of the given size.
    #
    # @param [Integer] size
    #
    # @return [String]
    #
    def random_hex(size)
      EncodedToken::Cipher::HEX_CHARS.sample(size).join
    end

    ##
    # Validates if the given object is a valid date/time.
    #
    # @param [Object] date
    #
    # @return [Boolean]
    #
    def valid_date?(date)
      return true if date.is_a?(Date)
      return true if date.is_a?(Time)
      return true if date.is_a?(DateTime)

      false
    end

    ##
    # Validates if the given input can be converted to an Integer.
    #
    # @param [Object] input
    #
    # @return [Boolean]
    #
    def valid_integer?(input)
      !!Integer(input)
    rescue
      false
    end

    ##
    # Validates if the given ID matches the UUID format.
    #
    # @param [String] id
    #
    # @return [Boolean]
    #
    def valid_uuid_format?(id)
      uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
      uuid_regex.match?(id.downcase)
    rescue
      false
    end

    ##
    # Validates if the given value contains only valid hex characters.
    #
    # @param [String] val
    #
    # @return [Boolean]
    #
    def valid_hex_text?(val)
      (val.chars - __hex_text.chars).empty?
    end

    ##
    # Validates if the given value contains only valid cipher characters.
    #
    # @param [String] val
    #
    # @return [Boolean]
    #
    def valid_token_text?(val)
      (val.chars - __cipher_text.chars).empty?
    end

    def __crc8_checksum(hex_string)
      data = [hex_string].pack('H*').bytes
      crc  = 0
      data.each do |byte|
        crc ^= byte
        8.times { crc = (crc & 0x80 != 0) ? ((crc << 1) ^ 0x07) : (crc << 1) }
        crc &= 0xFF
      end
      crc
    end

    def __hex_text
      EncodedToken::Cipher::HEX_TEXT
    end

    def __cipher_text
      EncodedToken::Cipher::CIPHER_TEXT
    end

    def __min_token_size
      EncodedToken::Encoder.min_token_size
    end

    def __max_input_size
      EncodedToken::Encoder.max_input_size
    end

  end
end
