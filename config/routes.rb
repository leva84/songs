# frozen_string_literal: true

Rails.application.routes.draw do
  resources :artists, only: [] do
    collection do
      get :songs_ordered_by_title
      get :songs_ordered_by_downloads_count
      get :top_artists_by_letter
    end
  end

  resources :songs, only: [] do
    collection do
      get :top_downloads
    end
  end
end
