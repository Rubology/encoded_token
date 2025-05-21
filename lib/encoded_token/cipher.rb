# frozen_string_literal: true

module EncodedToken
  ##
  # EncodedToken::Cipher
  #
  #   This class represents a cipher used by EncodedToken::Encryptor
  #   for encryption.
  #
  class Cipher

    # ======================================================================
    # = Macros
    # ======================================================================

    include EncodedToken::ErrorMessages

    # ======================================================================
    # = Constants
    # ======================================================================

    CIPHER_COUNT     = 16
    CIPHER_CHARS     = (('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a).freeze
    CIPHER_TEXT      = CIPHER_CHARS.join.freeze
    CIPHER_INDEX_MAP = CIPHER_TEXT.each_char.with_index.to_h.freeze
    HEX_CHARS        = (('a'..'f').to_a + ('A'..'F').to_a).freeze
    HEX_NUMS         = ('0'..'9').to_a.freeze
    SPECIAL_CHARS    = ['-'].freeze
    HEX_TEXT         = (HEX_NUMS + HEX_CHARS + SPECIAL_CHARS).join.freeze
    HEX_INDEX_MAP    = HEX_TEXT.each_char.with_index.to_h.freeze
    MAX_CIPHER_COUNT = 60

    # ======================================================================
    # = Instance Methods
    # ======================================================================

    ##
    # Initializes a new Cipher instance.
    #
    # @param [Integer] seed
    #   the seed for randomization.
    # @param [Date, Time, nil] expiry_date
    #   the date when this cipher expires.
    # @param [Integer] cipher_count
    #   the number of keys to generate.
    #
    def initialize(seed, expiry_date = nil, cipher_count = EncodedToken.configuration.cipher_count)
      @seed         = seed
      @expiry_date  = expiry_date
      @cipher_count = cipher_count

      build_cipher!
    end

    ##
    # Returns the seed used for this cipher.
    #
    # @return [Integer]
    #
    def seed
      @seed
    end

    ##
    # Returns a duplicate of the root key.
    #
    # @return [String]
    #
    def root_key
      @root_key.dup
    end

    ##
    # Sets the root key and resets the rotation.
    #
    # @param [String] new_key
    #   the new root key.
    #
    # @return [String]
    #   the new root key.
    #
    # @raise [ArgumentError]
    #   if the key is invalid.
    #
    def root_key=(new_key)
      fail_with(:invalid_root_key) unless valid_key?(new_key)
      @root_key = new_key
      reset!
    end

    ##
    # Resets the key rotation to the root key.
    #
    # @return [nil]
    #
    def reset!
      @rotation_key  = root_key
      @rotation_keys = keys.dup

      rotate_keys!(target_key: root_key)
      nil
    end

    ##
    # Rotates the current key.
    #
    # @param [String, nil] target_key
    #   the key to rotate to.
    #
    # @return [String]
    #   the new current rotation key.
    #
    # @raise [ArgumentError]
    #   if the target key is invalid.
    #
    def rotate_keys!(target_key: nil)
      if target_key
        # noinspection RubyMismatchedArgumentType
        unless valid_key?(target_key)
          fail_with(:invalid_root_key)
        end
        rotation_keys.rotate! until rotation_keys.first == target_key
      else
        rotation_keys.rotate!
      end

      @rotation_key = rotation_keys.first
    end

    ##
    # Checks if the given key is valid for this cipher.
    #
    # @param [String] key
    #
    # @return [Boolean]
    #
    def valid_key?(key)
      keys.include?(key)
    end

    ##
    # Returns the cipher text for the current rotation key.
    #
    # @return [String]
    #
    def text
      key_texts[@rotation_key]
    end

    ##
    # Returns the index map for the current rotation key.
    #
    # @return [Hash<String, Integer>]
    #
    def text_map
      key_maps[@rotation_key]
    end

    ##
    # Returns the padding size for the root key.
    #
    # @return [Integer]
    #
    def padding
      @key_paddings[@root_key]
    end

    ##
    # Returns the hex text used for encryption mapping.
    #
    # @return [String]
    #
    def hex_text
      HEX_TEXT
    end

    ##
    # Returns the index map for the hex text.
    #
    # @return [Hash<String, Integer>]
    #
    def hex_map
      HEX_INDEX_MAP
    end

    ##
    # Checks if the cipher has expired.
    #
    # @return [Boolean]
    #
    def expired?
      @expiry_date ? Time.now > @expiry_date : false
    end

    ##
    # Returns the number of keys in the cipher.
    #
    # @return [Integer]
    #
    def cipher_count
      @cipher_count
    end


    ##
    # Returns the current rotation key.
    #
    # @return [String]
    #
    def rotation_key
      @rotation_key
    end

    ##
    # Returns the map of keys to their respective cipher texts.
    #
    # @return [Hash<String, String>]
    #
    def key_texts
      @key_texts ||= {}
    end

    ##
    # Returns the map of keys to their respective index maps.
    #
    # @return [Hash<String, Hash>]
    #
    def key_maps
      @key_maps ||= {}
    end

    ##
    # Returns the map of keys to their respective padding sizes.
    #
    # @return [Hash<String, Integer>]
    #
    def key_paddings
      @key_paddings ||= {}
    end

    ##
    # Returns the list of keys.
    #
    # @return [Array<String>]
    #
    def keys
      @keys ||= []
    end

    ##
    # Returns the list of keys in their current rotation order.
    #
    # @return [Array<String>]
    #
    def rotation_keys
      @rotation_keys ||= []
    end

    # = Private Instance Methods
    # ======================================================================
    #
    private

    def build_cipher!
      return if keys.any?

      randomizer         = Random.new(seed)
      @keys              = CIPHER_CHARS.sample(cipher_count, random: randomizer)
      @root_key          = keys.sample(random: randomizer)
      @rotation_key      = @root_key
      @rotation_keys     = keys.dup

      rotate_keys! target_key: @rotation_key

      keys.each do |key|
        key_paddings[key] = randomizer.rand(0..10)
        key_texts[key]    = CIPHER_CHARS.sample(HEX_TEXT.size, random: randomizer).join
        key_maps[key]     = key_texts[key].each_char.with_index.to_h
      end
    end

  end # CipherPack
end
