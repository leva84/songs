# frozen_string_literal: true

describe Song, type: :model do
  subject { build(:song) }

  describe 'validations' do
    it { should validate_presence_of(:artist) }
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(124) }
    it { should validate_uniqueness_of(:title).scoped_to(:artist_id) }
  end

  describe 'associations' do
    it { should belong_to(:artist) }
    it { should have_many(:downloads).dependent(:destroy) }
  end

  describe 'instance methods' do
    it 'creates and saves a song' do
      expect { create(:song) }.to change(Song, :count).by(1)
    end
  end
end
