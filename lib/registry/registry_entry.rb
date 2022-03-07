require "active_model"

class RegistryEntry
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :baseurl, :string
end
