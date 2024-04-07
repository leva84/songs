# frozen_string_literal: true

class Artist < ApplicationRecord
  has_many :songs, dependent: :destroy

  validates :name, length: { minimum: 2, maximum: 124 }, uniqueness: true, presence: true
end
