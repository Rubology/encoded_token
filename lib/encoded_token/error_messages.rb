# frozen_string_literal: true

module EncodedToken
  ##
  # EncodedToken::ErrorMessages
  #
  #   This module contains all error handling and reporting functions.
  #
  module ErrorMessages

    # ======================================================================
    # = Constants
    # ======================================================================

    CONFIG_ERRORS = {
      invalid_cipher_count:     { error_klass: ArgumentError,
                                  message:     "cypher count must be an integer between 8 and 60." },
      invalid_expiry_argument:  { error_klass: ArgumentError,
                                  message:     'expiry seed must include an Integer seed, a Date or Time it expires & an Integer number of ciphers between 8 & 60 (default: 16).' },
      invalid_max_input_size:   { error_klass: ArgumentError,
                                  message:     'maximum input size must be an integer greater than 0.' },
      invalid_min_token_size:   { error_klass: ArgumentError,
                                  message:     'minimum token size must be an integer greater than 0.' },
      invalid_seed:             { error_klass: ArgumentError,
                                  message:     "seed must be an Integer, preferably with at least 5 digits. E.g. '12345'" },
      no_config_change_allowed: { error_klass: RuntimeError,
                                  message:     'configuration may not be changed once tokens have been encoded or decoded.' },
    }.freeze

    ENCRYPTOR_ERRORS = {
      invalid_encryption_char:  { error_klass: ArgumentError,
                                  message:     'invalid encryption character, must be hexadecimal.' },
      invalid_decryption_char:  { error_klass: ArgumentError,
                                  message:     'invalid decryption character.' },
      invalid_root_key:         { error_klass: ArgumentError,
                                  message:     'new cipher key is not included within the cipher key_list.' },
    }.freeze

    ENCODER_ERRORS = {
      invalid_token_characters: { error_klass: ArgumentError,
                                  message:     'invalid token characters.' },
      invalid_utf8_input:       { error_klass: ArgumentError,
                                  message:     'input must be an Integer, a String integer or a valid UTF-8 String.' },
      invalid_token:            { error_klass: ArgumentError,
                                  message:     'invalid token submitted.' },
      non_string_token:         { error_klass: ArgumentError,
                                  message:     'token must be a String.' },
    }.freeze


    CIPHER_ERRORS = {
      invalid_cipher_seed:      { error_klass: ArgumentError,
                                  message:     'cipher seed must be a positive Integer.' },
      unknown_cipher_seed:      { error_klass: ArgumentError,
                                  message:     'cipher seed not registered.' },
    }.freeze


    V1_ENCODER_ERRORS = {
      invalid_id:               { error_klass: ArgumentError,
                                  message:     'ID must be an Integer, a String integer or a String UUID.' },
    }.freeze

    ENCODED_TOKEN_ERRORS = {
      invalid_encoder:          { error_klass: ArgumentError,
                                  message:     'encoder should be blank, nil or :v1.' },
      seed_not_set:             { error_klass: RuntimeError,
                                  message:     "... looks like you haven't set a seed yet." }
    }.freeze

    ERROR_MESSAGES = {}.merge(CONFIG_ERRORS)
                        .merge(ENCRYPTOR_ERRORS)
                        .merge(ENCODER_ERRORS)
                        .merge(CIPHER_ERRORS)
                        .merge(V1_ENCODER_ERRORS)
                        .merge(ENCODED_TOKEN_ERRORS).freeze

    # ======================================================================
    # = Private Instance Methods
    # ======================================================================
    #
    private

    ##
    # Raises an exception corresponding to the given error key.
    #
    # @param [Symbol] error_key
    #   the key for the error message and class.
    #
    # @raise [ArgumentError, RuntimeError]
    #
    def fail_with(error_key)
      error_klass = ERROR_MESSAGES[error_key][:error_klass]
      message     = ERROR_MESSAGES[error_key][:message]
      error       = error_klass.new("\n\nERROR :=> EncodedToken: #{message}\n\n")
                               .tap { |e| e.set_backtrace(['EncodedToken']) unless ENV['ENCODEDTOKEN_DEBUG'] }
      fail error
    end

  end
end
