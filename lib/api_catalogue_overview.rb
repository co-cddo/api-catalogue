require_relative "url_helpers"

class ApiCatalogueOverview
  Entry = Struct.new(:name, :department, :license, :url, keyword_init: true)

  def initialize(catalogue)
    @catalogue = catalogue
  end

  def entries
    @entries ||= build_entries
  end

private

  attr_reader :catalogue

  def build_entries
    entries = catalogue.organisations_apis.flat_map do |organisation, apis|
      apis.map do |api|
        Entry.new(
          name: api.name,
          department: organisation.name,
          license: api.license,
          url: UrlHelpers.api_path(organisation: organisation, api: api),
        )
      end
    end

    entries.sort_by { |entry| entry.name.downcase }
  end
end
