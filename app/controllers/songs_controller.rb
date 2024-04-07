# frozen_string_literal: true

class SongsController < ApplicationController
  def top_downloads
    render json: collection_service.top_downloads
  end
end
