# frozen_string_literal: true

module EncodedToken
  module Encoder
    ##
    # EncodedToken::Encode::LegacyDecoder
    #
    #   This module represents a decoder used by EncodedToken::Encryptor
    #   to decode legacy tokens.
    #
    module LegacyDecoder

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
        # Decodes the given legacy token.
        #
        # @param [String] token
        #   the token to decode.
        #
        # @return [String, nil]
        #   the decoded value, or nil if unsuccessful.
        #
        # @raise [ArgumentError]
        #   if the token is invalid.
        #
        def decode(token)
          assert_valid_token!(token)
          parse_token(token)
        end

        # = Private Singleton Methods
        # ======================================================================
        #
        private

        def assert_valid_token!(token)
          fail_with(:non_string_token)         unless token.is_a?(String)
          fail_with(:invalid_token_characters) unless valid_token_text?(token)
        end

        # rubocop:disable Metrics/MethodLength
        #
        def parse_token(original_token)
          Encoder.decoding_ciphers.each do |cipher|
            begin
              token     = original_token.dup
              key       = token.slice!(0)
              encryptor = EncodedToken::Encryptor.new(cipher, key) rescue next

              # get the id size * padding
              id_size   = encryptor.decrypt(token.slice!(0, 2)).to_i(16)
              padding   = encryptor.padding

              # remove the padding, get and decrypt the id
              token.slice!(0, padding)
              enc_id    = token.slice!(0, id_size)
              id        = encryptor.decrypt(enc_id)

              # next cipher if it's  a UUID or numeric ID
              return id if valid_integer?(id) || valid_uuid_format?(id)

            rescue
              next
            end
          end

          nil
        end
        # rubocop:enable Metrics/MethodLength

      end # class << self
    end # module LegacyDecoder
  end # module encoder
end # module
