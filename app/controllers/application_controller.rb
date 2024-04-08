# frozen_string_literal: true

class ApplicationController < ActionController::API
  def collection_service
    @collection_service ||= CollectionService.new(params: params)
  end
end
