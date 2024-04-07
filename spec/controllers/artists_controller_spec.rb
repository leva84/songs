# frozen_string_literal: true

describe ArtistsController, type: :controller do
  describe 'GET #songs_ordered_by_title' do
    subject { get :songs_ordered_by_title, params: params }

    let(:artist) { create(:artist) }
    let!(:songs) { create_list(:song, 3, artist: artist) }
    let(:expected_data) { songs.pluck(:id, :title).to_json }
    let(:params) { { id: artist.id } }

    it 'returns success status' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns songs ordered by title' do
      subject
      expect(response.body).to eq(expected_data)
    end

    it 'calls songs_ordered_by_title method of CollectionService' do
      allow(CollectionService).to receive(:songs_ordered_by_title)
      subject
      expect(CollectionService).to have_received(:songs_ordered_by_title).with(params[:id].to_s)
    end
  end

  describe 'GET #songs_ordered_by_downloads_count' do
    subject { get :songs_ordered_by_downloads_count, params: params }

    let(:artist) { create(:artist) }
    let(:songs) { create_list(:song, 2, artist: artist) }
    let!(:download_first) { create(:download, count: 1, song: songs.first) }
    let!(:download_last) { create(:download, count: 2, song: songs.last) }
    let(:expected_data) { songs.reverse.pluck(:id, :title).to_json }
    let(:params) { { id: artist.id } }

    it 'returns success status' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns songs ordered by downloads count' do
      subject
      expect(response.body).to eq(expected_data)
    end

    it 'calls songs_ordered_by_downloads_count method of CollectionService' do
      allow(CollectionService).to receive(:songs_ordered_by_downloads_count)
      subject
      expect(CollectionService).to have_received(:songs_ordered_by_downloads_count).with(params[:id].to_s)
    end
  end

  describe 'GET #top_artists_by_letter' do
    subject { get :top_artists_by_letter, params: params }

    let!(:artists) { create_list(:artist, 5) }
    let(:count) { 2 }
    let(:expected_data) { [[artists.first.id, artists.first.name], [artists.last.id, artists.last.name]].to_json }
    let(:params) { { letter: 'A', count: count } }
    let!(:song1) { create(:song, artist: artists.first) }
    let!(:song2) { create(:song, artist: artists.last) }
    let!(:download1) { create(:download, count: 5, song: song1) }
    let!(:download2) { create(:download, count: 3, song: song2) }

    it 'returns success status' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns top artists by letter' do
      subject
      expect(response.body).to eq(expected_data)
    end

    it 'calls top_artists_by_letter method of CollectionService' do
      allow(CollectionService).to receive(:top_artists_by_letter)
      subject
      expect(CollectionService).to have_received(:top_artists_by_letter).with(params[:letter], params[:count].to_s)
    end
  end
end
