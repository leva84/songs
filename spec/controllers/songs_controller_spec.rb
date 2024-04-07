# frozen_string_literal: true

describe SongsController, type: :controller do
  describe 'GET #top_downloads' do
    subject { get :top_downloads, params: params }

    let!(:songs) { create_list(:song, 5) }
    let(:song1) { songs.first }
    let(:song2) { songs.last }
    let!(:download1) { create(:download, count: 5, song: song1) }
    let!(:download2) { create(:download, count: 3, song: song2) }
    let(:params) { { period: 'day', limit: limit } }
    let(:limit) { 2 }
    let(:expected_data) { [[songs.first.id, songs.first.title], [songs.last.id, songs.last.title]].to_json }

    it 'returns success status' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns top downloads for a specific period' do
      subject
      expect(response.body).to eq(expected_data)
    end

    it 'calls top_artists_by_letter method of CollectionService' do
      allow(CollectionService).to receive(:top_downloads)
      subject
      expect(CollectionService).to have_received(:top_downloads).with(params[:period], params[:limit].to_s)
    end
  end
end
