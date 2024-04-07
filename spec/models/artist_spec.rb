# frozen_string_literal: true

describe Artist, type: :model do
  subject { build(:artist) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(124) }
  end

  describe 'associations' do
    it { should have_many(:songs).dependent(:destroy) }
  end

  describe 'instance methods' do
    it 'creates and saves an artist' do
      expect { create(:artist) }.to change(Artist, :count).by(1)
    end
  end
end
