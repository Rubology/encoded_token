# frozen_string_literal: true

module EncodedToken
  ##
  # EncodedToken::Encryptor
  #
  #   This class is responsible for encryption and decryption.
  #
  class Encryptor

    # ======================================================================
    # = Macros
    # ======================================================================

    include EncodedToken::ErrorMessages

    # ======================================================================
    # = Instance Methods
    # ======================================================================

    ##
    # Validates if the given key is part of the cipher's key list.
    #
    # @param [String] key
    #   the key to validate.
    #
    # @return [Boolean]
    #   true if the key is valid, false otherwise.
    #
    def valid_key?(key)
      @cipher.valid_key?(key)
    end

    ##
    # Encrypts the given original string.
    #
    # @param [String] original_string
    #   the string to encrypt.
    #
    # @return [String]
    #   the encrypted string.
    #
    def encrypt(original_string)
      process_chars(original_string, :encrypt)
    end

    ##
    # Decrypts the given encrypted string.
    #
    # @param [String] encrypted_string
    #   the string to decrypt.
    #
    # @return [String]
    #   the decrypted string.
    #
    def decrypt(encrypted_string)
      process_chars(encrypted_string, :decrypt)
    end

    ##
    # Returns the random padding size for the current root key.
    #
    # @return [Integer]
    #   the padding size.
    #
    def padding
      @cipher.padding
    end

    ##
    # Returns the current root key.
    #
    # @return [String]
    #   the root key.
    #
    def key
      @root_key
    end

    ##
    # Returns the cipher instance.
    #
    # @return [Cipher]
    #   the cipher instance.
    #
    def cipher
      @cipher
    end

    # ======================================================================
    # = Private Instance Methods
    # ======================================================================
    #
    private

    def initialize(cipher, root_key = nil)
      @cipher = cipher

      if root_key
        fail_with(:invalid_root_key) unless @cipher.valid_key?(root_key)
        @cipher.root_key = root_key
      end

      @root_key = @cipher.root_key
    end

    def process_chars(input_string, action)
      cipher.reset!
      result = String.new

      input_string.each_char do |char|
        cipher.rotate_keys!
        result << (action == :decrypt ? decrypt_char(char) : encrypt_char(char))
      end
      result
    end


    def encrypt_char(char)
      position = cipher.hex_map[char]
      fail_with(:invalid_encryption_char) unless position
      cipher.text[position]
    end

    def decrypt_char(char)
      position = cipher.text_map[char]
      unless position
        fail_with(:invalid_decryption_char)
      end
      cipher.hex_text[position]
    end

  end
end
