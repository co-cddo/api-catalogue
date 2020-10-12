require "csv"
require_relative "api"
require_relative "organisation"

class ApiCatalogue
  def self.from_csv(csv_path)
    header_converter = ->(header) { header.underscore.to_sym }

    apis = CSV
      .foreach(csv_path, headers: true, header_converters: [header_converter])
      .map { |row| Api.new(row.to_hash) }

    new(apis)
  end

  attr_reader :organisations_apis

  def initialize(apis)
    @organisations_apis = group_by_organisation(apis)
  end

private

  def group_by_organisation(apis)
    apis
      .sort_by(&:organisation)
      .group_by(&:organisation)
      .each_with_object({}) do |(organisation, org_apis), result|
        organisation = Organisation.new(name: organisation, alternate_name: org_apis.first&.provider)
        result[organisation] = org_apis.sort_by(&:name)
      end
  end
end
