# frozen_string_literal: true

class ArtistsController < ApplicationController
  def songs_ordered_by_title
    render json: CollectionService.songs_ordered_by_title(params[:id])
  end

  def songs_ordered_by_downloads_count
    render json: CollectionService.songs_ordered_by_downloads_count(params[:id])
  end

  def top_artists_by_letter
    render json: CollectionService.top_artists_by_letter(params[:letter], params[:count])
  end
end
