# frozen_string_literal: true

require 'spec_helper'


RSpec.describe EncodedToken do

  # ======================================================================
  #  Encoding
  # ======================================================================
  
  describe 'encoding' do
    before(:each) {  
      EncodedToken::Base.class_variable_set :@@seed, nil
      EncodedToken.seed = 123 
    }


    #  :encode
    # ======================================================================
    context 'with :encode' do
      it "calls :encode! internally" do
        expect(EncodedToken).to receive(:encode!).once
        EncodedToken.encode(12345)
      end

      it "fails with a missing seed" do
        EncodedToken::Base.class_variable_set :@@seed, nil
        ENV['ENCODED_TOKEN_SEED'] = nil
        expect{EncodedToken.encode(12345)}
          .to raise_error RuntimeError, /Encryption seed must be set before using EncodedToken/
      end


      context 'with an Integer ID' do
        it 'returns a string token' do
          token = EncodedToken.encode(12345)
          expect(token.is_a?(String)).to be_truthy
        end

        it 'encrypts the ID within the token' do
          id = 12345
          token = EncodedToken.encode(id)
          expect(token).not_to include id.to_s
        end

        it 'produces a token of 55 characters' do
          id = 12345
          token = EncodedToken.encode(id)
          expect(token.size).to eq 55
        end
      end


      context 'with a String ID' do
        it 'returns a string token' do
          token = EncodedToken.encode('12345')
          expect(token.is_a?(String)).to be_truthy
        end

        it 'encrypts the ID within the token' do
          id = '12345'
          token = EncodedToken.encode(id)
          expect(token).not_to include id.to_s
        end

        it 'produces a token of 55 characters' do
          id = '12345'
          token = EncodedToken.encode(id)
          expect(token.size).to eq 55
        end
      end
  
      
      context 'with a String UUID' do
        it 'returns a string token' do
          uuid = SecureRandom.uuid
          token = EncodedToken.encode(uuid)
          expect(token.is_a?(String)).to be_truthy
        end

        it 'encrypts the UUID within the token' do
          uuid = SecureRandom.uuid
          token = EncodedToken.encode(uuid)
          expect(token).not_to include uuid.to_s
          expect(token).not_to include uuid.to_s.gsub('-','')
        end

        it 'produces a token of 55 characters' do
          uuid = SecureRandom.uuid
          token = EncodedToken.encode(uuid)
          expect(token.size).to eq 55
        end
      end

          
      context 'with an invalid ID' do
        it 'fails with an incorrectly formatted UUID' do
          uuid = '123412341-234-1234-1234-12345678'
          expect{EncodedToken.encode(uuid)}
            .to raise_error ArgumentError, /:id must be an Integer/
        end

        it 'fails with a code-breaking UUID' do
          allow_any_instance_of(Regexp).to receive(:match?).and_raise

          uuid = '12341234-1234-1234-1234-12345678'
          expect{EncodedToken.encode(uuid)}
            .to raise_error ArgumentError, /:id must be an Integer/
        end

        it 'fails with an non-numeric/hex character' do
          uuid = "aaaaaaaa-bbbb-cccx-dddd-eeeeeeeeeeee"
          expect{EncodedToken.encode(uuid)}
            .to raise_error ArgumentError, /:id must be an Integer/
        end

        it 'fails with a nil ID' do
          expect{EncodedToken.encode(nil)} 
            .to raise_error ArgumentError, /:id must be an Integer/
        end

        it 'fails with an empty ID' do
          expect{EncodedToken.encode('')}
            .to raise_error ArgumentError, /:id must be an Integer/
        end

        it 'fails with a non-integer/non-string ID' do
          obj = BasicObject.new
          expect{EncodedToken.encode(obj)} 
            .to raise_error ArgumentError, /:id must be an Integer/
        end

        it 'fails with number more than 255 characters long' do
          id = "1" * 256
          expect{EncodedToken.encode(id)} 
            .to raise_error ArgumentError, /:id must be an Integer/
        end
      end
    end #with :encode

  
  
    #  :encode!
    # ======================================================================
    context ':encode!' do
      it 'passes with a valid ID' do
        expect(EncodedToken.encode!(12345)).to be_truthy
      end

      it 'raises the original error with a non-Integer' do
        expect{EncodedToken.encode!(:a)}
          .to raise_error(ArgumentError, /must be an Integer, a String integer or a String UUID/)
      end
    end

  end #describe encoding 
end #RSpec.describe EncodedToken
