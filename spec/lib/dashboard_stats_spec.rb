require "api_catalogue"
require "dashboard_stats"

RSpec.describe DashboardStats do
  let(:csv_path) { File.expand_path("../../data/inputs/apic.csv", __dir__) }
  let(:api_catalogue) { ApiCatalogue.from_csv(csv_path) }

  subject { described_class.new(api_catalogue) }

  describe "#total_apis" do
    it "sums the APIs across each organisation" do
      expect(subject.total_apis).to be > 100
    end
  end

  describe "#total_organisations" do
    it "sums the number of organisations" do
      expect(subject.total_organisations).to be > 10
      expect(subject.total_organisations).to be < subject.total_apis
    end
  end

  describe "#last_updated" do
    let(:apis) do
      [
        instance_double(Api, organisation: "A", name: "A1", date_updated: Date.new(2020, 1, 1), date_added: Date.new(2016, 1, 1), provider: nil),
        instance_double(Api, organisation: "A", name: "A2", date_updated: Date.new(2019, 1, 1), date_added: Date.new(2016, 1, 1), provider: nil),
        instance_double(Api, organisation: "B", name: "B1", date_updated: Date.new(2018, 1, 1), date_added: Date.new(2016, 1, 1), provider: nil),
        instance_double(Api, organisation: "C", name: "C1", date_updated: Date.new(2017, 1, 1), date_added: Date.new(2016, 1, 1), provider: nil),
      ]
    end

    let(:api_catalogue) { ApiCatalogue.new(apis) }

    it "matches the most recently updated API" do
      expect(subject.last_updated).to eq Date.new(2020, 1, 1)
    end
  end

  describe "#by_organisation" do
    it "provides stats per organisation" do
      nhs_stats = subject.by_organisation.detect do |stats|
        stats.organisation.name.casecmp?("National Health Service")
      end

      expect(nhs_stats).to have_attributes(
        organisation: have_attributes(name: "National Health Service"),
        api_count: (a_value > 30),
        first_added: be_a(Date),
        last_updated: be_a(Date),
      )
    end

    it "orders the organisations by number of APIs" do
      subject.by_organisation.each_cons(2) do |org1, org2|
        expect(org1.api_count).to be >= org2.api_count
      end
    end
  end
end
