# frozen_string_literal: true

describe ArtistsController, type: :controller do
  describe 'GET #songs_ordered_by_title' do
    let(:artist) { create(:artist) }
    let!(:songs) { create_list(:song, 3, artist: artist) }

    it 'returns songs ordered by title' do
      get :songs_ordered_by_title, params: { id: artist.id }
      expect(response).to have_http_status(:success)
      expect(response.body).to eq(songs.pluck(:title).to_json)
    end
  end

  describe 'GET #songs_ordered_by_downloads_count' do
    let(:artist) { create(:artist) }
    let!(:songs) { create_list(:song, 3, artist: artist) }

    it 'returns songs ordered by downloads count' do
      get :songs_ordered_by_downloads_count, params: { id: artist.id }
      expect(response).to have_http_status(:success)
      expect(response.body).to eq(songs.pluck(:title, :downloads_count).to_json)
    end
  end

  describe 'GET #top_artists_by_letter' do
    let!(:artists) { create_list(:artist, 5, name: 'Test Artist') }

    it 'returns top artists by letter' do
      get :top_artists_by_letter, params: { letter: 'T', count: 3 }
      expect(response).to have_http_status(:success)
      expect(response.body).to eq(artists.pluck(:name).to_json)
    end
  end
end
