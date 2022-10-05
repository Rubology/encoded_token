# frozen_string_literal: true


##
# EncodedToken version details
#
class EncodedToken # :nodoc:

  ##
  # The EncodedToken gem version.
  #
  # [returns:]
  #   - the version of the currently loaded EncodedToken as a <tt>Gem::Version</tt>
  #
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end



  module VERSION # :nodoc: all

    MAJOR = 1
    MINOR = 0
    TINY  = 2
    # MICRO = ''

    STRING = [MAJOR, MINOR, TINY].compact.join(".")
    # STRING = [MAJOR, MINOR, TINY, MICRO].compact.join(".")

  end

end
