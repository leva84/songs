# frozen_string_literal: true

class SongsController < ApplicationController
  def top_downloads
    render json: CollectionService.top_downloads(params[:period], params[:limit])
  end
end
