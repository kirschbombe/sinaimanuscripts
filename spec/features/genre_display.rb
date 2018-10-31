# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'The genre field of the item display view', :clean, js: false do
  before do
    solr = Blacklight.default_index.connection
    solr.add(work_attributes)
    solr.commit
  end

  let(:work_attributes) do
    {
      id: '123_genre_display',
      genre_tesim: ['genre1', 'genre2', 'genre3'],
    }
  end
  
  it 'lists each genre on its own line, as a link to a search for that genre' do
    visit('/catalog/123_genre_display')
    page.within('dd.blacklight-genre_tesim') do
      # test for genre_tesim.length-1 = 3-1 = 2 <br> tags
      # if someone who knows rspec & capybara wanted to make sure they're in
      # between the genre names, that'd be even better! -abw, 10/30/2018
      expect(all(:css, 'br').length).to eq 2
      
      genre_links = all(:css, 'a.genre').to_a.map{|a| a['href']}
      expect(genre_links).to contain_exactly(
        '/catalog?f%5Bgenre_sim%5D%5B%5D=genre1',
        '/catalog?f%5Bgenre_sim%5D%5B%5D=genre2',
        '/catalog?f%5Bgenre_sim%5D%5B%5D=genre3'
      )
    end
  end
end
