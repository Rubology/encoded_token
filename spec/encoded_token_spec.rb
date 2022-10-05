# frozen_string_literal: true

require 'spec_helper'


RSpec.describe EncodedToken do

  # ======================================================================
  # = Instantiation
  # ======================================================================

  describe 'instantiation' do
    it "is prohibited" do
      expect{EncodedToken.new}.to raise_error NotImplementedError, /abstract class/
    end
  end

end #RSpec.describe EncodedToken
