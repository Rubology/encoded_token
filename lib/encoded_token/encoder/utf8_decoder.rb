# frozen_string_literal: true

module EncodedToken
  module Encoder
    ##
    # EncodedToken::Encode::Utf8Decoder
    #
    #   This module represents the decoder used by EncodedToken::Encryptor
    #   to decode UTF-8 tokens.
    #
    module Utf8Decoder

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
        # Decodes the given UTF-8 token.
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

        
        # ======================================================================
        # = Private Singleton Methods
        # ======================================================================
        #
        private

        def assert_valid_token!(token)
          fail_with(:non_string_token)         unless token.is_a?(String)
          fail_with(:invalid_token)            unless token[-1] == '_'
          fail_with(:invalid_token_characters) unless valid_token_text?(token[0..-2])
        end

        # rubocop:disable Metrics
        #
        def parse_token(original_token)
          Encoder.decoding_ciphers.each do |cipher|
            begin
              token     = original_token[0..-2]
              key       = token.slice!(0)
              encryptor = EncodedToken::Encryptor.new(cipher, key) rescue next

              hex_token    = encryptor.decrypt(token)
              padding_size = encryptor.padding
              hex_token.slice!(0, padding_size)

              data_size    = hex_token.slice!(0, 3).to_i(16)
              hex_data     = hex_token.slice!(0, data_size)
              crc_checksum = hex_token.slice!(0, 2).to_i(16)

              next unless crc_checksum == __crc8_checksum(hex_data)

              [hex_data].pack("H*").force_encoding("UTF-8")
            rescue
              next
            end.tap { |result| return result if result }
          end # each cipher
          nil
        end
        # rubocop:enable Metrics

      end # class << self

    end # module Utf8Decoder
  end # module encoder
end # module
