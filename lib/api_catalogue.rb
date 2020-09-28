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
      .each_with_object({}) do |(organisation, apis), result|
        organisation = Organisation.new(name: organisation, alternate_name: apis.first&.provider)
        result[organisation] = apis.sort_by(&:name)
      end

    new(data)
  end

  attr_reader :organisations_apis

  def initialize(organisations_apis)
    @organisations_apis = organisations_apis
  end

  private

  attr_reader :data
end
