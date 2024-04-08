# frozen_string_literal: true

class ArtistsController < ApplicationController
  def songs_ordered_by_title
    render json: collection_service.songs_ordered_by_title
  end

  def songs_ordered_by_downloads_count
    render json: collection_service.songs_ordered_by_downloads_count
  end

  def top_artists_by_letter
    render json: collection_service.top_artists_by_letter
  end
end
