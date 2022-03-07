require "net/http"
require_relative "api"
require_relative "organisation"
require_relative "csv_source"
require_relative "fetcher"
require_relative "registry"

class ApiCatalogue
  def self.from_csv(catalogue_csv:, organisation_csv:)
    apis = CsvSource.load(catalogue_csv) { |attributes| Api.new(attributes) }
    organisations = CsvSource.load(organisation_csv) { |attributes| Organisation.new(attributes) }

    new(apis: apis, organisations: organisations)
  end

  def self.from_url(url)
    FetcherService.instance.fetch(url)
  rescue ClientError
    ApiCatalogue.new(apis: [], organisations: [])
  end

  def self.from_urls(registry_entries_csv)
    registry_entries = CsvSource.load(registry_entries_csv) { |attributes| RegistryEntry.new(attributes) }
    url_catalogues = registry_entries.map do |entry|
      from_url(entry.baseurl)
    end
    merge(url_catalogues)
  end

  def self.merge(api_catalogues)
    all_apis = []
    all_orgs = []
    api_catalogues.each do |catalogue|
      catalogue.organisations_apis.each do |org, apis|
        all_orgs << org
        all_apis << apis
      end
    end

    new(apis: all_apis.flatten.uniq(&:attributes), organisations: all_orgs.uniq(&:attributes))
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
