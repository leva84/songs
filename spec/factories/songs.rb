# frozen_string_literal: true

FactoryBot.define do
  factory :song do
    association :artist
    sequence(:title) { |n| "Song #{n}" }
  end
end
