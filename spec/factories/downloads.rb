# frozen_string_literal: true

FactoryBot.define do
  factory :download do
    association :song
  end
end
