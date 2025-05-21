# frozen_string_literal: true

module EncodedToken
  module Encoder
    ##
    # EncodedToken::Encode::LegacyEncoder
    #
    #   This module represents the encoder used by EncodedToken::Encryptor
    #   to encode legacy tokens.
    #
    module LegacyEncoder

      # ======================================================================
      # = Macros
      # ======================================================================

      extend EncodedToken::Utils
      extend EncodedToken::ErrorMessages

      # ======================================================================
      # = Singleton Methods
      # ======================================================================

      class << self

        ##
        # Encodes the given ID into a legacy token.
        #
        # @param [Integer, String, *.to_s] id
        #   the ID to encode.
        #
        # @return [String]
        #   the encoded legacy token.
        #
        # @raise [ArgumentError]
        #   if the ID is invalid.
        #
        def encode(id)
          assert_valid_id!(id)
          generate_token(id)
        end

        # = Private Singleton Methods
        # ======================================================================
        #
        private

        def assert_valid_id!(id)
          sid = id.to_s
          fail if     sid.empty? || sid.size > 255
          fail unless valid_hex_text?(sid)
          fail unless valid_integer?(sid) || valid_uuid_format?(sid)

          true
        rescue StandardError
          fail_with(:invalid_id)
        end


        # rubocop:disable Metrics/MethodLength
        #
        def generate_token(id, user_key = nil)
          encryptor    = EncodedToken::Encryptor.new(Encoder.encoding_cipher, user_key)
          padding_size = encryptor.padding
          sid          = id.to_s
          hex_sid_size = hex_id_size(sid)

          token = [
            encryptor.key,
            encryptor.encrypt(hex_sid_size),
            random_characters(padding_size),
            encryptor.encrypt(sid)
          ].join

          pad_to_min_token_size(token)
        end
        # rubocop:enable Metrics/MethodLength


        def hex_id_size(sid)
          sid.size.to_s(16).rjust(2, '0')
        end


        def pad_to_min_token_size(token)
          return token if token.size >= __min_token_size

          padding = random_characters(__min_token_size)
          (token + padding).slice(0, __min_token_size)
        end

      end # class << self

    end # module LegacyEncoder
  end # module encoder
end # module
