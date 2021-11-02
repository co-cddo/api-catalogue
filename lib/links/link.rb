require "active_model"

class Link
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :date_added, :date
  attribute :url, :string
  attribute :title, :string

  validates :date_added, presence: true
  validates :url, presence: true
  validates :title, presence: true
end
