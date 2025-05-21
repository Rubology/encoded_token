# frozen_string_literal: true

module EncodedToken
  module Encoder
    ##
    # EncodedToken::Encode::Utf8Encoder
    #
    #   This module represents a encoder used by EncodedToken::Encryptor
    #   to encode UTF-8 tokens.
    #
    module Utf8Encoder

      # ======================================================================
      # = Mcros
      # ======================================================================

      extend EncodedToken::Utils
      extend EncodedToken::ErrorMessages


      # ======================================================================
      # = Singleton methods
      # ======================================================================

      class << self

        ##
        # Encodes the given input into a UTF-8 token.
        #
        # @param [Integer, String, *.to_s] input
        #   the input to encode.
        #
        # @return [String]
        #   the encoded UTF-8 token.
        #
        # @raise [ArgumentError]
        #   if the input is invalid.
        #
        def encode(input)
          assert_valid_input!(input)
          generate_token(input)
        end


        # = Private Singleton Methods
        # ======================================================================
        #
        private

        def assert_valid_input!(input)
          utf8 = input.to_s.force_encoding("UTF-8")
          fail if utf8.empty? || utf8.size > __max_input_size

          true
        rescue StandardError
          fail_with(:invalid_utf8_input)
        end

        # rubocop:disable Metrics
        #
        def generate_token(input, user_key = nil)
          encryptor    = EncodedToken::Encryptor.new(Encoder.encoding_cipher, user_key)
          padding_size = encryptor.padding

          token = [
            random_hex(padding_size),
            hex_input_size(input),
            hex_input(input),
            crc_checksum(input),
            random_hex(padding_size),
            random_hex(rand(20).to_i)
          ].join

          token = pad_to_min_token_size(token)

          [encryptor.key, encryptor.encrypt(token), '_'].join
        end
        # rubocop:enable Metrics

        def hex_input(input)
          input.to_s.force_encoding("UTF-8").unpack1('H*')
        end

        def hex_input_size(input)
          hex_input(input).size.to_s(16).rjust(3, '0')
        end

        def crc_checksum(input)
          __crc8_checksum(hex_input(input)).to_s(16).rjust(2, '0')
        end

        def pad_to_min_token_size(token)
          return token if token.size >= __min_token_size

          padding = random_hex(__min_token_size)
          (token + padding).slice(0, __min_token_size)
        end

      end # class << self

    end # class Utf8Encoder
  end # module encoder
end # module
