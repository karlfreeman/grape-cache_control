require 'spec_helper'

describe Grape::Cache do
  subject { Class.new(Grape::API) }

  def app
    subject
  end

  describe 'cache_control' do
    it 'allows for headers to be set' do
      subject.get('/apples') do
        cache_control :public, max_age: 60.0
        "apples"
      end

      get 'apples'
      expect(last_response.headers['Cache-Control']).not_to be_nil
      expect(last_response.headers['Cache-Control'].split(', ')).to eq ['public', 'max-age=60']
      expect(last_response.body).to eql('apples')
    end
    it 'infers true for symbols and removes false hash values' do
      subject.get('/pears') do
        cache_control :public, no_cache: true, no_store: false
        "pears"
      end

      get 'pears'
      expect(last_response.headers['Cache-Control']).not_to be_nil
      expect(last_response.headers['Cache-Control'].split(', ')).to eq ['public', 'no-cache']
      expect(last_response.body).to eql('pears')
    end
    it 'merges?' do
      subject.get('/grapes') do
        cache_control :public, max_age: 60
        cache_control :private
        "grapes"
      end

      get 'grapes'
      expect(last_response.headers['Cache-Control']).not_to be_nil
      expect(last_response.headers['Cache-Control'].split(', ')).to eq ['private', 'max-age=60']
      expect(last_response.body).to eql('grapes')
    end
  end

  describe 'expires' do
    it 'sets Expires header and passes along cache_control values' do
      subject.get('/grapefruits') do
        expires 60, :public, :no_cache
        "grapefruits"
      end

      get 'grapefruits'
      expect(last_response.headers['Cache-Control']).not_to be_nil
      expect(last_response.headers['Cache-Control'].split(', ')).to eq ['public', 'no-cache', 'max-age=60']
      expect(last_response.headers['Expires']).to eq (Time.now + 60).httpdate
      expect(last_response.body).to eql('grapefruits')
    end
  end
end