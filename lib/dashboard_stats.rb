class DashboardStats
  OrganisationStats = Struct.new(
    :organisation, :api_count, :first_added, :last_updated, keyword_init: true
  )

  def initialize(api_catalogue)
    @api_catalogue = api_catalogue
  end

  def total_apis
    api_catalogue.organisations_apis.sum do |_, apis|
      apis.count
    end
  end

  def total_organisations
    api_catalogue.organisations_apis.count
  end

  def last_updated
    by_organisation.max_by(&:last_updated)&.last_updated
  end

  def by_organisation
    @by_organisation ||= calculate_stats_by_organisation
  end

private

  attr_reader :api_catalogue

  def calculate_stats_by_organisation
    api_catalogue
      .organisations_apis
      .map(&method(:build_organisation_stats))
      .sort_by(&:api_count)
      .reverse
  end

  def build_organisation_stats(organisation, apis)
    OrganisationStats.new(
      organisation: organisation,
      api_count: apis.count,
      first_added: apis.min_by(&:date_added)&.date_added,
      last_updated: apis.max_by(&:date_updated)&.date_updated,
    )
  end
end
