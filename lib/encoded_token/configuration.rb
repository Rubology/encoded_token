# frozen_string_literal: true

module EncodedToken
  ##
  # EncodedToken::Configuration
  #
  #   This class manages the single configuration instance for EncodedToken.
  #
  class Configuration

    # ======================================================================
    # = Macros
    # ======================================================================

    include EncodedToken::ErrorMessages
    include EncodedToken::Utils

    # ======================================================================
    # = Constants
    # ======================================================================

    DEFAULT_CIPHER_COUNT   = 16
    DEFAULT_MIN_TOKEN_SIZE = 55
    DEFAULT_MAX_INPUT_SIZE = 1000

    # ======================================================================
    # = Class methods
    # ======================================================================

    private_class_method :new

    class << self

      ##
      # Returns the singleton instance of the Configuration.
      #
      # @return [Configuration]
      #
      def instance
        @instance ||= new
      end

      ##
      # Checks if the configuration is locked.
      #
      # @return [Boolean]
      #
      def locked?
        instance.locked?
      end

      ##
      # Checks if the configuration is unlocked.
      #
      # @return [Boolean]
      #
      def unlocked?
        instance.unlocked?
      end

      ##
      # Locks the configuration to prevent further changes.
      #
      # @return [true]
      #   the lock status
      #
      def lock!
        instance.lock!
      end

      ##
      # Unlocks the configuration.
      #
      # @return [false]
      #   the lock status
      #
      def unlock!
        instance.unlock!
      end

    end # class << self

    # ======================================================================
    # = Instance Methods
    # ======================================================================

    def initialize
      @cipher_count       = DEFAULT_CIPHER_COUNT
      @expiring_seeds     = {}
      @locked             = false
      @max_input_size     = DEFAULT_MAX_INPUT_SIZE
      @min_token_size     = DEFAULT_MIN_TOKEN_SIZE
    end

    ##
    # Checks if the configuration is locked.
    #
    # @return [Boolean]
    #
    def locked?
      !!@locked
    end

    ##
    # Checks if the configuration is unlocked.
    #
    # @return [Boolean]
    #
    def unlocked?
      !locked?
    end

    ##
    # Locks the configuration.
    #
    # @return [true] the lock status
    #
    def lock!
      @locked = true
    end

    ##
    # Unlocks the configuration.
    #
    # @return [false] the lock status
    #
    def unlock!
      @locked = false
    end

    ##
    # Adds an expiring seed to the configuration.
    #
    # @param [Integer, String] expiring_seed
    #   the seed for the expiring cipher.
    # @param [Date, Time] expiry_date
    #   the date when the seed expires.
    # @param [Integer] cipher_count
    #   the number of keys for the expiring cipher.
    #
    # @return [Hash]
    #   the details of the added expiring seed.
    #
    # @raise [ArgumentError]
    #   if the arguments are invalid.
    #
    def add_expiring_seed(expiring_seed, expiry_date, cipher_count = DEFAULT_CIPHER_COUNT)
      assert_configuration_can_change!

      key     = Integer(expiring_seed).abs rescue nil
      c_count = Integer(cipher_count).abs rescue nil

      if key && valid_date?(expiry_date) && valid_cipher_count?(c_count)
        @expiring_seeds[key] = {expires_on: expiry_date, cipher_count: c_count}
      else
        fail_with(:invalid_expiry_argument)
      end
    end

    ##
    # Returns the default cipher count.
    #
    # @return [Integer]
    #
    def cipher_count
      @cipher_count
    end

    ##
    # Sets the default cipher count.
    #
    # @param [Integer] new_count
    #   the new cipher count.
    #
    # @raise [ArgumentError, RuntimeError]
    #   if the count is invalid or configuration is locked.
    #
    def cipher_count=(new_count)
      assert_configuration_can_change!

      value = Integer(new_count).abs rescue nil
      fail_with(:invalid_cipher_count) unless valid_cipher_count?(value)

      @cipher_count = value
    end

    ##
    # Returns the map of expiring seeds.
    #
    # @return [Hash<Integer, Hash>]
    #
    def expiring_seeds
      @expiring_seeds || {}
    end

    ##
    # Returns the maximum input size.
    #
    # @return [Integer]
    #
    def max_input_size
      @max_input_size
    end

    ##
    # Sets the maximum input size.
    #
    # @param [Integer] max_size
    #
    # @raise [ArgumentError, RuntimeError]
    #   if the size is invalid or configuration is locked.
    #
    def max_input_size=(max_size)
      assert_configuration_can_change!

      value = Integer(max_size).abs rescue nil
      fail_with(:invalid_max_input_size) if value.nil? || !value.positive?

      @max_input_size = value
    end

    ##
    # Returns the minimum token size.
    #
    # @return [Integer]
    #
    def min_token_size
      @min_token_size
    end

    ##
    # Sets the minimum token size.
    #
    # @param [Integer] min_size
    #
    # @raise [ArgumentError, RuntimeError]
    #   if the size is invalid or configuration is locked.
    #
    def min_token_size=(min_size)
      assert_configuration_can_change!

      value = Integer(min_size).abs rescue nil
      fail_with(:invalid_min_token_size) if value.nil? || !value.positive?

      @min_token_size = value
    end

    ##
    # Returns the master seed.
    #
    # @return [Integer]
    #
    def seed
      @seed
    end

    ##
    # Sets the master seed.
    #
    # @param [Integer] new_seed
    #
    # @raise [ArgumentError, RuntimeError]
    #   if the seed is invalid or configuration is locked.
    #
    def seed=(new_seed)
      assert_configuration_can_change!

      value = Integer(new_seed).abs rescue nil
      fail_with(:invalid_seed) if value.nil?

      @seed = value
    end

    # = Private Instance Methods
    # ======================================================================
    #
    private

    def assert_configuration_can_change!
      fail_with(:no_config_change_allowed) if locked?
    end

    def valid_cipher_count?(count)
      return true if count.is_a?(Integer) && count >= 8 && count <= Cipher::MAX_CIPHER_COUNT
      fail_with(:invalid_expiry_argument)
    end

  end # class configuration
end
