# frozen_string_literal: true

describe Download, type: :model do
  subject { build(:download) }

  describe 'validations' do
    it { should validate_presence_of(:song) }
    it { should validate_uniqueness_of(:download_date).scoped_to(:song_id) }
  end

  describe 'associations' do
    it { should belong_to(:song) }
  end

  describe 'instance methods' do
    it 'creates and saves a download' do
      expect { create(:download) }.to change(Download, :count).by(1)
    end
  end

  describe 'default values' do
    let!(:download) { create(:download) }

    it 'sets default value for count' do
      expect(download.count).to eq(0)
    end

    it 'sets default value for download_date' do
      expect(download.download_date).to eq(Date.today)
    end
  end
end
