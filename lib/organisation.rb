require "active_model"

class Organisation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :name, :string
  attribute :alternate_name, :string
  attribute :url, :string

  def slug
    alternate_name.parameterize
  end
end
