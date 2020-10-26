require "api"
require "active_support/core_ext"

FactoryBot.define do
  factory :api do
    transient do
      sequence :api_number
    end

    name { "API-#{api_number}" }
    url { "https://api-#{api_number}.example.com" }

    date_added { 1.year.ago.to_date }
    date_updated { 1.month.ago.to_date }

    skip_create
  end
end
