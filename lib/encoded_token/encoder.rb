# frozen_string_literal: true

module EncodedToken
  ##
  # EncodedToken::Encoder
  #
  #   This module handles the encoding and decoding of tokens.
  #
  module Encoder

    # ======================================================================
    # = Macros
    # ======================================================================

    extend EncodedToken::ErrorMessages


    # ======================================================================
    # = Singleton Methods
    # ======================================================================

    class << self

      ##
      # Checks if the ciphers have been built.
      #
      # @return [Boolean]
      #   true if the encoding cipher is set, false otherwise.
      #
      def ciphers_built?
        !!encoding_cipher
      end

      ##
      # Returns a duplicate of the current encoding cipher.
      #
      # @return [Cipher]
      #   the encoding cipher instance.
      #
      def encoding_cipher
        @encoding_cipher.dup
      end

      ##
      # Returns a list of duplicates of the current decoding ciphers.
      #
      # @return [Array<Cipher>]
      #   an array of decoding cipher instances.
      #
      def decoding_ciphers
        @decoding_ciphers ||= []
        @decoding_ciphers.map{ |cipher| cipher.dup }
      end

      ##
      # Returns the minimum token size from configuration.
      #
      # @return [Integer]
      #   the minimum size for an encoded token.
      #
      def min_token_size
        EncodedToken.configuration.min_token_size
      end

      ##
      # Returns the maximum input size from configuration.
      #
      # @return [Integer]
      #   the maximum size allowed for input.
      #
      def max_input_size
        EncodedToken.configuration.max_input_size
      end

      ##
      # Encodes a given input to an encoded token.
      #
      # @param [Integer, String, *.to_s] input
      #   any object that responds to '.to_s'
      # @param [:utf8, :legacy] encoder
      #   the encoder to use.
      #
      # @return [String] if successful
      # @return [nil]    if unsuccessful
      #
      def encode(input, encoder = :utf8)
        encode!(input, encoder)
      rescue StandardError
        nil
      end

      ##
      # Encodes a given input to an encoded token, raising an exception
      # if encountered.
      #
      # @param [Integer, String, *.to_s] input
      #   any object that responds to '.to_s'
      # @param [:utf8, :legacy] encoder
      #   the encoder to use.
      #
      # @return [String] the encoded token
      #
      # @raise [ArgumentError, RuntimeError]
      #   if the encoding fails or if the seed is not set.
      #
      def encode!(input, encoder = :utf8)
        fail_with(:seed_not_set) unless encoding_cipher

        case encoder
        when :utf8
          Encoder::Utf8Encoder.encode(input)
        when :legacy
          Encoder::LegacyEncoder.encode(input)
        else
          fail_with(:invalid_encoder)
        end
      end

      ##
      # Decodes a given token to the original string.
      #
      # @param [String] token
      #   an encoded-token string
      #
      # @return [String]
      #   the decoded value if successful
      # @return [nil]
      #   if unsuccessful
      #
      def decode(token)
        decode!(token)
      rescue
        nil
      end

      ##
      # Decodes a given token to the original string, raising an exception
      # if encountered.
      #
      # @param [String] token
      #   an encoded-token string
      #
      # @return [String]
      #   the decoded value
      #
      # @raise [ArgumentError, RuntimeError]
      #   if the decoding fails, if the token is not a string, or if the seed is not set.
      #
      def decode!(token)
        fail_with(:seed_not_set)     unless encoding_cipher
        fail_with(:non_string_token) unless token.is_a?(String)

        if token[-1] == '_'
          Utf8Decoder.decode(token)
        else
          LegacyDecoder.decode(token)
        end
      end

      ##
      # Builds the encoding and decoding ciphers based on the current configuration.
      #
      # @return [void]
      #
      # @raise [RuntimeError]
      #   if the seed is not set in the configuration.
      #
      def build_ciphers!
        default_seed = EncodedToken.configuration.seed || fail_with(:seed_not_set)

        @encoding_cipher  = Cipher.new(default_seed)
        @decoding_ciphers = [@encoding_cipher]

        EncodedToken.configuration.expiring_seeds.each do |exp_seed, details|
          cipher = Cipher.new(exp_seed, details[:expires_on], details[:cipher_count])
          @decoding_ciphers << cipher unless cipher.expired?
        end
      end

    end # class << self

  end #module
end #EncodedToken
