require "csv"
require_relative "api"
require_relative "organisation"

class ApiCatalogue
  def self.from_csv(catalogue_csv:, organisation_csv:)
    header_converter = ->(header) { header.underscore.to_sym }

    apis = CSV
      .foreach(catalogue_csv, headers: true, header_converters: [header_converter])
      .map { |row| Api.new(row.to_hash) }

    organisations = CSV
      .foreach(organisation_csv, headers: true, header_converters: [header_converter])
      .map { |row| Organisation.new(row.to_hash) }

    new(apis: apis, organisations: organisations)
  end

  attr_reader :organisations_apis

  def initialize(apis:, organisations:)
    @organisations_apis = group_by_organisation(apis: apis, organisations: organisations)
  end

private

  def group_by_organisation(apis:, organisations:)
    provider_apis = apis.sort_by(&:name).group_by(&:provider)

    organisations.sort_by(&:name).map { |organisation|
      [organisation, provider_apis.fetch(organisation.id, [])]
    }.to_h
  end
end
