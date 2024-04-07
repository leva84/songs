# frozen_string_literal: true

class Song < ApplicationRecord
  belongs_to :artist
  has_many :downloads, dependent: :destroy

  validates :artist, :title, presence: true
  validates :title, length: { maximum: 124 }, uniqueness: { scope: :artist_id }
end
