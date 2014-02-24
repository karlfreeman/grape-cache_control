require 'spec_helper'

describe Grape::CacheControl do
  subject { Class.new(Grape::API) }

  def app
    subject
  end

  context 'helpers' do

    describe 'cache_control' do
      it 'sets default headers' do
        subject.get('/oranges') do
          cache_control
        end

        get 'oranges'
        expect(last_response.headers['Cache-Control'].split(', ')).to include('private', 'must-revalidate', 'max-age=0')
      end

      it 'sets headers' do
        subject.get('/apples') do
          cache_control :public, max_age: 60.0
        end

        get 'apples'
        expect(last_response.headers['Cache-Control'].split(', ')).to include('public', 'max-age=60')
      end

      it 'treats symbols as true and hash keys with true values the same' do
        subject.get('/pears') do
          cache_control :public, no_cache: true
        end

        get 'pears'
        expect(last_response.headers['Cache-Control'].split(', ')).to include('public', 'no-cache')
      end

      it 'merges previous cache_control headers' do
        subject.get('/grapes') do
          cache_control :public, max_age: 60, s_maxage: 30
          cache_control :private
        end

        get 'grapes'
        expect(last_response.headers['Cache-Control'].split(', ')).to include('private', 'max-age=60', 's-maxage=30')
      end

      it 'allows removal of previous headers by setting a hash keys value as false' do
        subject.get('/pears') do
          cache_control :public, no_cache: true
          cache_control :private, no_cache: false
        end

        get 'pears'
        expect(last_response.headers['Cache-Control'].split(', ')).to_not include('no-cache')
        expect(last_response.headers['Cache-Control'].split(', ')).to include('private')
      end

      it 'ignores unsettable directives' do
        subject.get('/cherrys') do
          cache_control public: 60, max_age: 60
        end

        get 'cherrys'
        expect(last_response.headers['Cache-Control'].split(', ')).to_not include('public')
        expect(last_response.headers['Cache-Control'].split(', ')).to include('max-age=60')
      end
    end

    describe 'expires' do
      it 'sets Expires header and passes along Cache-Control values' do
        subject.get('/grapefruits') do
          expires 60, :public, :no_cache
        end

        get 'grapefruits'
        expect(last_response.headers['Cache-Control'].split(', ')).to include('max-age=60', 'public', 'no-cache')
        expect(last_response.headers['Expires']).to eq((Time.now + 60).httpdate)
      end

      it 'allows Time to be specified as the expiry' do
        subject.get('/grapefruits') do
          expires((Time.now + 60), :public, :no_cache)
        end

        get 'grapefruits'
        expect(last_response.headers['Cache-Control'].split(', ')).to include('max-age=60', 'public', 'no-cache')
        expect(last_response.headers['Expires']).to eq((Time.now + 60).httpdate)
      end
    end

  end

end
