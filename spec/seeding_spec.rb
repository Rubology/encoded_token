# frozen_string_literal: true

require 'spec_helper'


RSpec.describe EncodedToken do

  # ======================================================================
  #  Setting the Seed
  # ======================================================================

  describe "setting the seed" do
    describe "with :seed=" do
      before(:each){ 
        EncodedToken::Base.class_variable_set :@@seed, nil
        ENV['ENCODED_TOKEN_SEED'] = "123.4"
      }

      context 'passes with' do
        it "an integer" do
          expect(EncodedToken.seed = 123).to be_truthy
        end

        it "an string integer" do
          expect(EncodedToken.seed = "123").to be_truthy
        end
      end


      context "fails with" do
        it "the seed already set" do
          expect(EncodedToken.seed = 123).to be_truthy
          expect{EncodedToken.seed = 123}.to raise_error ArgumentError, /seed has alreay been set/
        end

        it "nil" do
          expect{EncodedToken.seed = nil}.to raise_error ArgumentError, /seed must be an Integer/
        end

        it "a date" do
          expect{EncodedToken.seed = Time.now}.to raise_error ArgumentError, /seed must be an Integer/
        end

        it "a flaot" do
          expect{EncodedToken.seed = 23.5}.to raise_error ArgumentError, /seed must be an Integer/
        end

        it "a blank string" do
          expect{EncodedToken.seed = ''}.to raise_error ArgumentError, /seed must be an Integer/
        end

        it "an invalid object" do
          expect{EncodedToken.seed = BasicObject.new}.to raise_error ArgumentError, /seed must be an Integer/
        end
      end
    end #with :seed=

    describe "with ENV['ENCODED_TOKEN_SEED']" do
      before(:each){ 
        EncodedToken::Base.class_variable_set :@@seed, nil 
        ENV['ENCODED_TOKEN_SEED'] = nil 
      }

      context 'passes with' do
        it "an integer string" do
          ENV['ENCODED_TOKEN_SEED'] = "123"
          expect(EncodedToken.encode! 456).to be_truthy
        end
      end


      context "fails with" do
        it "a blank string" do
          ENV['ENCODED_TOKEN_SEED'] = ''
          expect{EncodedToken.encode! 456}.to raise_error RuntimeError, /ENV\['ENCODED_TOKEN_SEED'\] must be a string encoded Integer/
        end

        it "a float string" do
          ENV['ENCODED_TOKEN_SEED'] = "123.4"
          expect{EncodedToken.encode! 456}.to raise_error RuntimeError, /ENV\['ENCODED_TOKEN_SEED'\] must be a string encoded Integer/
        end

        it "a text string" do
          ENV['ENCODED_TOKEN_SEED'] = "1 test"
          expect{EncodedToken.encode! 456}.to raise_error RuntimeError, /ENV\['ENCODED_TOKEN_SEED'\] must be a string encoded Integer/
        end
      end
    end #with ENV['ENCODED_TOKEN_SEED']
  end #setting the seed



  # ======================================================================
  #  Proving the Seed
  # ======================================================================

  describe "proving the seed" do
    before(:each) {
      EncodedToken::Base.class_variable_set :@@seed, nil
      ENV['ENCODED_TOKEN_SEED'] = nil
    }

    let(:cipher_count) { EncodedToken::Base::CIPHER_COUNT }

    it "generates #{EncodedToken::Base::CIPHER_COUNT} ciphers" do
      expect(EncodedToken.seed = rand(4321)).to be_truthy
      expect(EncodedToken::Base.class_variable_get(:@@ciphers).size).to eq cipher_count
    end


    it "generates different cipher-text for each key" do
      expect(EncodedToken.seed = rand(4321)).to be_truthy

      ciphers      = EncodedToken::Base.class_variable_get(:@@ciphers)
      cipher_texts = ciphers.map{ |k,v| v[:cipher_text] }
      expect(cipher_texts.size).to      eq cipher_count
      expect(cipher_texts.uniq.size).to eq cipher_count
    end
    
    it "generates random padding for each key" do
      # note: duplicate values are likely
      expect(EncodedToken.seed = rand(4321)).to be_truthy

      ciphers  = EncodedToken::Base.class_variable_get(:@@ciphers)
      paddings = ciphers.map{ |k,v| v[:padding] }
      expect(paddings.size).to          eq cipher_count
      expect(paddings.uniq.size > 3).to be_truthy
    end
    
    it "re-generates the same ciphers for the same key each time" do
      seed = rand(4321)
      expect(EncodedToken.seed = seed).to be_truthy

      base_ciphers      = EncodedToken::Base.class_variable_get(:@@ciphers)
      base_cipher_keys  = base_ciphers.keys.sort
      expect(base_cipher_keys.size).to eq cipher_count

      # reset and try again with the same seed
      EncodedToken::Base.class_variable_set :@@seed, nil
      ENV['ENCODED_TOKEN_SEED'] = nil

      expect(EncodedToken.seed = seed).to be_truthy
      test_ciphers      = EncodedToken::Base.class_variable_get(:@@ciphers)
      test_cipher_keys  = test_ciphers.keys.sort
      
      expect(test_cipher_keys.size).to eq cipher_count
      expect(test_cipher_keys).to eq base_cipher_keys

      base_cipher_keys.each do |key|
        expect(test_ciphers[key][:cipher_text]).to eq test_ciphers[key][:cipher_text]
        expect(test_ciphers[key][:padding]).to eq test_ciphers[key][:padding]
      end

      # reset and try a final with the same seed
      EncodedToken::Base.class_variable_set :@@seed, nil
      ENV['ENCODED_TOKEN_SEED'] = nil

      expect(EncodedToken.seed = seed).to be_truthy
      new_ciphers      = EncodedToken::Base.class_variable_get(:@@ciphers)
      new_cipher_keys  = new_ciphers.keys.sort
      
      expect(new_cipher_keys.size).to eq cipher_count
      expect(new_cipher_keys).to eq base_cipher_keys

      base_cipher_keys.each do |key|
        expect(new_ciphers[key][:cipher_text]).to eq new_ciphers[key][:cipher_text]
        expect(new_ciphers[key][:padding]).to eq new_ciphers[key][:padding]
      end
    end #re-generates the same ciphers for the same key each time

    it "generates different ciphers for different keys" do
      expect(EncodedToken.seed = 1).to be_truthy

      base_ciphers      = EncodedToken::Base.class_variable_get(:@@ciphers)
      base_cipher_keys  = base_ciphers.keys.sort
      base_cipher_texts = base_ciphers.map{ |k,v| v[:cipher_text] }
      expect(base_cipher_keys.size).to eq cipher_count

      # reset and try a again with a new same seed
      EncodedToken::Base.class_variable_set :@@seed, nil
      ENV['ENCODED_TOKEN_SEED'] = nil

      expect(EncodedToken.seed = 3).to be_truthy
      test_ciphers      = EncodedToken::Base.class_variable_get(:@@ciphers)
      test_cipher_keys  = test_ciphers.keys.sort
      test_cipher_texts = test_ciphers.map{ |k,v| v[:cipher_text] }

      expect(test_cipher_keys.size).to                          eq cipher_count
      expect(test_cipher_keys).not_to                           eq base_cipher_keys
      expect((test_cipher_texts - base_cipher_texts).size).to   eq cipher_count

      # reset and try a final time with the same seed
      EncodedToken::Base.class_variable_set :@@seed, nil
      ENV['ENCODED_TOKEN_SEED'] = nil

      expect(EncodedToken.seed = 2).to be_truthy
      new_ciphers      = EncodedToken::Base.class_variable_get(:@@ciphers)
      new_cipher_keys  = new_ciphers.keys.sort
      new_cipher_texts = new_ciphers.map{ |k,v| v[:cipher_text] }

      expect(new_cipher_keys.size).to                         eq cipher_count
      expect(new_cipher_keys).not_to                          eq base_cipher_keys
      expect((new_cipher_texts - base_cipher_texts).size).to  eq cipher_count
      expect(new_cipher_keys).not_to                          eq test_cipher_keys
      expect((new_cipher_texts - test_cipher_texts).size).to  eq cipher_count
    end #generates different ciphers for different keys

    
  end #proving the seed
end #RSpec.describe EncodedToken
