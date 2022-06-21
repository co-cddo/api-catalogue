require "api_catalogue"
require "webmock/rspec"

RSpec.describe ApiCatalogue do
  describe "::from_csv" do
    let(:catalogue_csv) { File.expand_path("../../data/catalogue.csv", __dir__) }
    let(:organisation_csv) { File.expand_path("../../data/organisation.csv", __dir__) }

    it "parses the CSV sources" do
      api_catalogue = described_class.from_csv(
        catalogue_csv: catalogue_csv,
        organisation_csv: organisation_csv,
      )

      expect(api_catalogue.organisations_apis.size).to be > 10

      gds, gds_apis = api_catalogue.organisations_apis.detect do |org, _|
        org.name.casecmp?("Government Digital Service")
      end

      notify_api = gds_apis.detect do |api|
        api.name.casecmp?("GOV.UK Notify")
      end

      expect(gds).to have_attributes(
        name: "Government Digital Service",
        alternate_name: "GDS",
      )

      expect(notify_api).to have_attributes(
        name: "GOV.UK Notify",
        description: be_present,
        url: "https://api.notifications.service.gov.uk/",
      )
    end
  end

  describe "::from_url" do
    it "returns an empty catalogue if a 406 error is raised" do
      stub_request(:get, "http://localhost/subpath/apis")
        .to_return(status: 406)

      api_catalogue = described_class.from_url("http://localhost/subpath")

      expect(api_catalogue.organisations_apis.size).to be 0
    end

    it "returns an empty catalogue if a 404 error is raised" do
      stub_request(:get, "http://localhost/subpath/apis")
        .to_return(status: 404)

      api_catalogue = described_class.from_url("http://localhost/subpath")

      expect(api_catalogue.organisations_apis.size).to be 0
    end
  end

  describe "::from_urls" do
    let(:registry_entries_csv) { File.expand_path("../../data/registry_entries.csv", __dir__) }

    before do
      apis_response = {
        "api-version": "api.gov.uk/v1alpha",
        apis: [
          "api-version": "api.gov.uk/v1alpha",
          data: {
            name: "test API",
            description: "test description",
            url: "www.foo.bar",
            "documentation-url": "www.docs.foo.bar",
            organisation: "Test Org",
          },
        ],
      }

      stub_request(:get, %r{/apis})
        .with(headers: { "correlation-id" => /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-4[a-fA-F0-9]{3}-[89abAB][a-fA-F0-9]{3}-[a-fA-F0-9]{12}/, "accept" => "application/vnd.uk.gov.api.v1alpha+json" })
        .to_return(status: 200, body: apis_response.to_json)
    end

    it "parses the CSV source" do
      api_catalogue = described_class.from_urls(registry_entries_csv)

      expect(api_catalogue.organisations_apis.size).to be > 0
    end
  end

  describe "::merge" do
    api_one = Api.new name: "Test Api One", provider: "Test Org One"
    apis_one = [api_one]
    org_one = Organisation.new id: "Test Org One"
    orgs_one = [org_one]
    catalogue_one = described_class.new(apis: apis_one, organisations: orgs_one)

    api_two = Api.new name: "Test Api Two", provider: "Test Org Two"
    apis_two = [api_two]
    org_two = Organisation.new id: "Test Org Two"
    orgs_two = [org_two]
    catalogue_two = described_class.new(apis: apis_two, organisations: orgs_two)

    it "merges two catalogues together" do
      merged_catalogue = described_class.merge([catalogue_one, catalogue_two])

      test_orgs = merged_catalogue.organisations_apis.select { |orgs, _| orgs }

      expect(test_orgs.size).to be 2

      test_apis = merged_catalogue.organisations_apis.select { |_, apis| apis }

      expect(test_apis.size).to be 2
    end

    it "does not add duplicate APIs" do
      merged_catalogue = described_class.merge([catalogue_one, catalogue_one])

      test_apis = merged_catalogue.organisations_apis.select { |_, apis| apis }

      expect(test_apis.size).to be 1
    end

    it "does not add duplicate organisations" do
      merged_catalogue = described_class.merge([catalogue_one, catalogue_one])

      test_orgs = merged_catalogue.organisations_apis.select { |orgs, _| orgs }

      expect(test_orgs.size).to be 1
    end
  end

  describe "ordering" do
    it "sorts organisations and APIs from A-Z" do
      apis = [
        build(:api, provider: "B", name: "B2"),
        build(:api, provider: "B", name: "B1"),
        build(:api, provider: "A", name: "A2"),
        build(:api, provider: "A", name: "A1"),
      ]

      organisations = [
        build(:organisation, id: "B", name: "B-Org"),
        build(:organisation, id: "A", name: "A-Org"),
      ]

      api_catalogue = described_class.new(apis: apis, organisations: organisations)
      first_org, first_org_apis = api_catalogue.organisations_apis.first

      expect(first_org.name).to eq "A-Org"
      expect(first_org_apis.map(&:name)).to eq %w[A1 A2]
    end
  end
end
