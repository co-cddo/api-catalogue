require "api"
require "active_support/core_ext"

FactoryBot.define do
  factory :organisation do
    transient do
      sequence :org_number
    end

    id { org_number.to_s }
    name { "Org-#{org_number}" }
    url { "https://org-#{org_number}.example.com" }

    skip_create
  end
end
