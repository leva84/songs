# frozen_string_literal: true

describe SongsController, type: :controller do
  describe 'GET #top_downloads' do
    let!(:songs) { create_list(:song, 5) }

    it 'returns top downloads for a specific period' do
      get :top_downloads, params: { period: 'day', limit: 3 }
      expect(response).to have_http_status(:success)
      expect(response.body).to eq(songs.pluck(:title).to_json)
    end
  end
end
