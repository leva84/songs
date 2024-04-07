# frozen_string_literal: true

class Download < ApplicationRecord
  belongs_to :song

  validates :song, presence: true
  validates :download_date, uniqueness: { scope: :song_id }

  before_create :set_default_download_date

  private

  def set_default_download_date
    self.download_date ||= Date.today
  end
end
