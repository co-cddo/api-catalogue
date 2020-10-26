require "active_model"

class Api
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :date_added, :date
  attribute :date_updated, :date
  attribute :url, :string
  attribute :name, :string
  attribute :description, :string
  attribute :documentation, :string
  attribute :license, :string
  attribute :maintainer, :string
  attribute :provider, :string
  attribute :area_served, :string
  attribute :start_date, :date
  attribute :end_date, :date

  def slug
    name.parameterize
  end
end
