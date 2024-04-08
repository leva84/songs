# frozen_string_literal: true

describe ArtistsController, type: :controller do
  let(:collection_service) { instance_double(CollectionService) }

  describe 'GET #songs_ordered_by_title' do
    subject { get :songs_ordered_by_title, params: params }

    let(:artist) { create(:artist) }
    let!(:songs) { create_list(:song, 3, artist: artist) }

    let(:expected_data) { songs.pluck(:id, :title) }
    let(:params) { { artist_id: artist.id } }

    context 'when id parameter are provided' do
      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns songs ordered by title' do
        subject
        expect(response.body).to eq(expected_data.to_json)
      end

      it 'calls songs_ordered_by_title method of CollectionService' do
        expect(CollectionService).to receive(:new).and_return(collection_service)
        expect(collection_service).to receive(:songs_ordered_by_title).and_return(expected_data)
        subject
      end
    end

    context 'when id parameter are not provided' do
      let(:params) { {} }

      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns songs ordered by title' do
        subject
        expect(response.body).to eq([].to_json)
      end

      it 'calls songs_ordered_by_title method of CollectionService' do
        expect(CollectionService).to receive(:new).and_return(collection_service)
        expect(collection_service).to receive(:songs_ordered_by_title)
        subject
      end
    end
  end

  describe 'GET #songs_ordered_by_downloads_count' do
    subject { get :songs_ordered_by_downloads_count, params: params }

    let(:artist) { create(:artist) }
    let(:songs) { create_list(:song, 2, artist: artist) }

    let!(:download_first) { create(:download, count: 1, song: songs.first) }
    let!(:download_last) { create(:download, count: 2, song: songs.last) }

    let(:expected_data) { songs.reverse.pluck(:id, :title).to_json }
    let(:params) { { artist_id: artist.id } }

    context 'when id parameter are provided' do
      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns songs ordered by downloads count' do
        subject
        expect(response.body).to eq(expected_data)
      end

      it 'calls songs_ordered_by_downloads_count method of CollectionService' do
        expect(CollectionService).to receive(:new).and_return(collection_service)
        expect(collection_service).to receive(:songs_ordered_by_downloads_count).and_return(expected_data)
        subject
      end
    end

    context 'when id parameter are not provided' do
      let(:params) { {} }

      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns songs ordered by downloads count' do
        subject
        expect(response.body).to eq([].to_json)
      end

      it 'calls songs_ordered_by_downloads_count method of CollectionService' do
        expect(CollectionService).to receive(:new).and_return(collection_service)
        expect(collection_service).to receive(:songs_ordered_by_downloads_count)
        subject
      end
    end
  end

  describe 'GET #top_artists_by_letter' do
    subject { get :top_artists_by_letter, params: params }

    let!(:artists) { create_list(:artist, 5) }
    let(:limit) { 2 }
    let(:params) { { letter: 'A', limit: limit } }

    let!(:song1) { create(:song, artist: artists.first) }
    let!(:song2) { create(:song, artist: artists.last) }

    let!(:download1) { create(:download, count: 5, song: song1) }
    let!(:download2) { create(:download, count: 3, song: song2) }

    let(:expected_data) do
      [
        [artists.first.id, artists.first.name],
        [artists.last.id, artists.last.name]
      ]
    end

    context 'when letter and limit parameters are provided' do
      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns top artists by letter' do
        subject
        expect(response.body).to eq(expected_data.to_json)
      end

      it 'calls top_artists_by_letter method of CollectionService' do
        expect(CollectionService).to receive(:new).and_return(collection_service)
        expect(collection_service).to receive(:top_artists_by_letter).and_return(expected_data)
        subject
      end
    end

    context 'when letter and limit parameters are not provided' do
      let(:params) { {} }
      let(:expected_data) { sorted_artists.pluck(:id, :name) }
      let(:sorted_artists) do
        artists.sort_by { |artist| artist.songs.joins(:downloads).sum('downloads.count') }
      end

      before do
        artists.each do |artist|
          create(:download, count: 3, song: create(:song, artist: artist))
        end
      end

      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns all top artists' do
        subject
        expect(response.body).to match(expected_data.to_json)
      end

      it 'calls top_artists_by_letter method of CollectionService' do
        expect(CollectionService).to receive(:new).and_return(collection_service)
        expect(collection_service).to receive(:top_artists_by_letter).and_return(expected_data)
        subject
      end
    end
  end
end
