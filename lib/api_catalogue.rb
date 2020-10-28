require_relative "api"
require_relative "organisation"
require_relative "csv_source"

class ApiCatalogue
  def self.from_csv(catalogue_csv:, organisation_csv:)
    apis = CsvSource.load(catalogue_csv) { |attributes| Api.new(attributes) }
    organisations = CsvSource.load(organisation_csv) { |attributes| Organisation.new(attributes) }

    new(apis: apis, organisations: organisations)
  end

  attr_reader :organisations_apis

  def initialize(apis:, organisations:)
    @organisations_apis = group_by_organisation(apis: apis, organisations: organisations)
  end

private

  def group_by_organisation(apis:, organisations:)
    apis_by_provider = apis.sort_by(&:name).group_by(&:provider)

    organisations
      .sort_by(&:name)
      .each_with_object({}) do |organisation, result|
        result[organisation] = apis_by_provider.fetch(organisation.id, [])
      end
  end
end
