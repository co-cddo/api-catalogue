require "active_model"

class Organisation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :alternate_name, :string

  def slug
    alternate_name.parameterize
  end
end
