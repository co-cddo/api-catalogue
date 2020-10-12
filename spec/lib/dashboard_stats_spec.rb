require "api_catalogue"
require "dashboard_stats"

RSpec.describe DashboardStats do
  subject(:stats) { described_class.new(api_catalogue) }

  let(:csv_path) { File.expand_path("../../data/inputs/apic.csv", __dir__) }
  let(:api_catalogue) { ApiCatalogue.from_csv(csv_path) }

  describe "#total_apis" do
    it "sums the APIs across each organisation" do
      expect(stats.total_apis).to be > 100
    end
  end

  describe "#total_organisations" do
    it "sums the number of organisations" do
      expect(stats.total_organisations).to be > 10
      expect(stats.total_organisations).to be < stats.total_apis
    end
  end

  describe "#last_updated" do
    let(:apis) do
      [
        build(:api, organisation: "A", date_updated: "2020-1-1"),
        build(:api, organisation: "A", date_updated: "2019-1-1"),
        build(:api, organisation: "B", date_updated: "2018-1-1"),
        build(:api, organisation: "C", date_updated: "2017-1-1"),
      ]
    end

    let(:api_catalogue) { ApiCatalogue.new(apis) }

    it "matches the most recently updated API, across all organisations" do
      expect(stats.last_updated).to eq Date.new(2020, 1, 1)
    end
  end

  describe "#by_organisation" do
    it "provides stats per organisation" do
      nhs_stats = stats.by_organisation.detect do |org_stats|
        org_stats.organisation.name.casecmp?("National Health Service")
      end

      expect(nhs_stats).to have_attributes(
        organisation: have_attributes(name: "National Health Service"),
        api_count: (a_value > 30),
        first_added: be_a(Date),
        last_updated: be_a(Date),
      )
    end

    it "orders the organisations by number of APIs" do
      stats.by_organisation.each_cons(2) do |org1, org2|
        expect(org1.api_count).to be >= org2.api_count
      end
    end
  end
end
