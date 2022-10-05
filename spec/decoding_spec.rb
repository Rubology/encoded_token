# frozen_string_literal: true

require 'spec_helper'


RSpec.describe EncodedToken do

  # ======================================================================
  #  Decoding
  # ======================================================================
  
  describe 'decoding' do
    before(:each) {  
      EncodedToken::Base.class_variable_set :@@seed, nil
      EncodedToken.seed = 123 
    }


    #  :decode
    # ======================================================================
    context ':decode' do
      it "calls :decode! internally" do
        token = EncodedToken.encode(12345)
        expect(EncodedToken).to receive(:decode!).once
        EncodedToken.decode(token)
      end

            
      context 'with a valid ID token' do
        it 'returns the correct String ID' do
          id     = '12345'
          token  = EncodedToken.encode(id)
          result = EncodedToken.decode(token)
          # binding.break
          expect(result.is_a?(String)).to be_truthy
          expect(result).to eq id
        end
      end


      context 'with a valid UUID token' do
        it 'returns the correct UUID' do
          uuid   = SecureRandom.uuid
          token  = EncodedToken.encode(uuid)
          result = EncodedToken.decode(token)
          expect(result).to eq uuid
        end
      end


      context 'with an invalid token' do
        it 'fails with a nil token' do
          expect(EncodedToken.decode(nil)).to be_nil
        end

        it 'fails with a non-integer/non-string token' do
          obj = BasicObject.new
          expect(EncodedToken.decode(obj)).to be_nil
        end

        it 'fails with non-cipher characters' do
          uuid          = SecureRandom.uuid
          token         = EncodedToken.encode(uuid)
          changed_token = token
          
          # remove the middle character
          mid = token.size/2
          changed_token[mid] = 'ê'
                   
          expect(EncodedToken.decode(changed_token)).to be_nil
        end

      end
      
      context "with a :decrypt code failure" do
        it "fails with an invalid token error" do
          uuid          = SecureRandom.uuid
          token         = EncodedToken.encode(uuid)

          #remove cipher texts to cause an internal failure
          ciphers = EncodedToken::Base.class_variable_get(:@@ciphers)
          ciphers.each do |k,v|
            ciphers[k][:cipher_text] = nil
          end
          EncodedToken::Base.class_variable_set(:@@ciphers, ciphers)

          expect(EncodedToken.decode(token)).to be_nil
        end
      end
      
      context "with a valid token built with a different seed" do
        it "returns the wrong UUID" do
          uuid          = SecureRandom.uuid
          token         = EncodedToken.encode(uuid)

          EncodedToken::Base.class_variable_set :@@seed, nil
          EncodedToken.seed = 124 

          expect(EncodedToken.decode(token)).not_to eq uuid
        end
      end  

      context "with a token with an invalid cipher key" do
        it "returns the wrong UUID" do
          keylist     = EncodedToken::Base.class_variable_get :@@keylist
          uuid        = SecureRandom.uuid
          token       = EncodedToken.encode(uuid)

          missing_key =(('a'..'z').to_a - keylist).sample
          token[0]    = missing_key
          expect(EncodedToken.decode(token)).to be_nil
        end
      end  
    end #:decode


    #  :decode!
    # ======================================================================
    context ':decode!' do
      it 'passes with a valid token' do
        token = EncodedToken.encode(12345)
        expect(EncodedToken.decode!(token)).to eq "12345"
      end

      it 'raises the original error with a non-Integer' do
        expect{EncodedToken.decode!(:a)}
          .to raise_error(RuntimeError, /Token is not a string/)
      end
    end

  end #decoding
end #RSpec.describe EncodedToken
