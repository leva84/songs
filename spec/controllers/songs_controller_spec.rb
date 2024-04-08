# frozen_string_literal: true

describe SongsController, type: :controller do
  let(:collection_service) { instance_double(CollectionService) }

  describe 'GET #top_downloads' do
    subject { get :top_downloads, params: params }

    let!(:songs) { create_list(:song, 5) }
    let(:song1) { songs.first }
    let(:song2) { songs.last }

    let!(:download1) { create(:download, count: 5, song: song1) }
    let!(:download2) { create(:download, count: 3, song: song2) }

    let(:expected_data) do
      [
        [songs.first.id, songs.first.title],
        [songs.last.id, songs.last.title]
      ]
    end

    context 'when period and limit parameters are provided' do
      let(:params) { { period: 'day', limit: limit } }
      let(:limit) { 2 }

      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns top downloads for a specific period' do
        subject
        expect(response.body).to eq(expected_data.to_json)
      end

      it 'calls top_downloads method of CollectionService' do
        expect(CollectionService).to receive(:new).and_return(collection_service)
        expect(collection_service).to receive(:top_downloads).and_return(expected_data)
        subject
      end
    end

    context 'when period and limit parameters are not provided' do
      let(:params) { {} }

      it 'returns success status' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns top downloads with default limit' do
        subject
        expect(response.body).to eq(expected_data.to_json)
      end

      it 'calls top_downloads method of CollectionService with default limit' do
        expect(CollectionService).to receive(:new).and_return(collection_service)
        expect(collection_service).to receive(:top_downloads).and_return(expected_data)
        subject
      end
    end
  end
end
