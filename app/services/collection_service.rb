# frozen_string_literal: true

class CollectionService
  class << self
    def songs_ordered_by_title(artist_id)
      Artist.find(artist_id)
            .songs
            .order(:title)
            .pluck(:id, :title)
    end

    def songs_ordered_by_downloads_count(artist_id)
      Artist.find(artist_id)
            .songs
            .left_joins(:downloads)
            .group('songs.id')
            .order('SUM(downloads.count) DESC')
            .pluck(:id, :title)
    end

    def top_artists_by_letter(letter, count)
      Artist.where('artists.name LIKE ?', "%#{ letter }%")
            .joins(songs: :downloads)
            .group('artists.id')
            .order('SUM(downloads.count) DESC')
            .limit(count.to_i)
            .pluck(:id, :name)
    end

    def top_downloads(period, limit)
      relation = case period
                 when 'day'
                   Song.where(downloads: { download_date: Date.today })
                 when 'week'
                   Song.where('downloads.download_date >= ?', 1.week.ago)
                 when 'month'
                   Song.where('downloads.download_date >= ?', 1.month.ago)
                 else
                   raise ArgumentError, 'Invalid period'
                 end

      relation.left_joins(:downloads)
              .group(:id)
              .order('COUNT(downloads.count) DESC')
              .limit(limit)
              .pluck(:id, :title)
    end
  end
end
