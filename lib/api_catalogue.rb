require "csv"
require_relative "api"
require_relative "organisation"

class ApiCatalogue
  def self.from_csv(csv_path)
    header_converter = lambda { |header| header.underscore.to_sym }

    data = CSV
      .foreach(csv_path, headers: true, header_converters: [header_converter])
      .map { |row| Api.new(row.to_hash) }
      .group_by(&:organisation)
      .map { |organisation, apis| [Organisation.new(name: organisation, alternate_name: apis.first&.provider), apis] }
      .to_h

    new(data)
  end

  def initialize(data)
    @data = data
  end

  def organisations_apis
    data.each
  end

  private

  attr_reader :data
end
