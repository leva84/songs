# frozen_string_literal: true

class CollectionService
  DEFAULT_LIMIT = 10

  attr_reader :params

  def initialize(params:)
    @params = params
  end

  def songs_ordered_by_title
    return [] if artist.nil?

    artist
      .songs
      .order(:title)
      .pluck(:id, :title)
  end

  def songs_ordered_by_downloads_count
    return [] if artist.nil?

    artist
      .songs
      .left_joins(:downloads)
      .group('songs.id')
      .order('SUM(downloads.count) DESC')
      .pluck(:id, :title)
  end

  def top_artists_by_letter
    artists_by_letter
      .joins(songs: :downloads)
      .group('artists.id')
      .order('SUM(downloads.count) DESC')
      .limit(limit)
      .pluck(:id, :name)
  end

  def top_downloads
    songs_by_period
      .left_joins(:downloads)
      .group(:id)
      .order('COUNT(downloads.count) DESC')
      .limit(limit)
      .pluck(:id, :title)
  end

  private

  def artist
    @artist ||= Artist.find_by(id: params[:artist_id])
  end

  def letter
    @letter ||= params[:letter]
  end

  def limit
    @limit ||= (params[:limit] || DEFAULT_LIMIT).to_i
  end

  def period
    @period ||= params[:period] || 'day'
  end

  def songs_by_period
    @songs_by_period ||= case period
                         when 'day'
                           Song.where(downloads: { download_date: Date.today })
                         when 'week'
                           Song.where('downloads.download_date >= ?', 1.week.ago)
                         when 'month'
                           Song.where('downloads.download_date >= ?', 1.month.ago)
                         end

  end

  def artists_by_letter
    @artists_by_letter ||= if letter.present?
                             Artist.where('artists.name LIKE ?', "%#{ letter }%")
                           else
                             Artist.all
                           end
  end
end
