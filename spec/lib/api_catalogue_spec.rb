require "api_catalogue"
require "tempfile"
require "webmock/rspec"

RSpec.describe ApiCatalogue do
  describe "::from_csv" do
    let(:catalogue_csv) { File.expand_path("../../data/catalogue.csv", __dir__) }
    let(:organisation_csv) { File.expand_path("../../data/organisation.csv", __dir__) }

    it "parses the CSV sources" do
      api_catalogue = described_class.from_csv(
        catalogue_csv:,
        organisation_csv:,
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

    context "with synthetic CSV fixtures for bulk import" do
      def with_csvs(catalogue_content, organisation_content)
        Tempfile.create(["catalogue", ".csv"]) do |cat_file|
          Tempfile.create(["organisation", ".csv"]) do |org_file|
            cat_file.write(catalogue_content)
            cat_file.flush
            org_file.write(organisation_content)
            org_file.flush
            yield cat_file.path, org_file.path
          end
        end
      end

      let(:organisations_csv) do
        <<~CSV
          id,name,alternateName,url
          example-dept,Example Department,EXD,https://example.gov.uk
          other-dept,Other Department,OD,https://other.gov.uk
        CSV
      end

      let(:apis_csv) do
        <<~CSV
          dateAdded,dateUpdated,url,name,description,documentation,license,maintainer,areaServed,startDate,endDate,provider
          2024-01-15,2024-02-01,https://api.example.gov.uk/one,API One,First API,https://docs/one,MIT,team@example.gov.uk,UK,2024-01-01,,example-dept
          2024-03-10,2024-03-10,https://api.example.gov.uk/two,API Two,Second API,https://docs/two,MIT,team@example.gov.uk,UK,,,example-dept
          2024-04-01,2024-04-01,https://api.other.gov.uk/three,API Three,Third API,https://docs/three,MIT,team@other.gov.uk,UK,,,other-dept
        CSV
      end

      it "imports every row and groups APIs under their providing organisation" do
        with_csvs(apis_csv, organisations_csv) do |cat_path, org_path|
          catalogue = described_class.from_csv(catalogue_csv: cat_path, organisation_csv: org_path)

          expect(catalogue.organisations_apis.keys.map(&:name))
            .to contain_exactly("Example Department", "Other Department")

          example, example_apis = catalogue.organisations_apis.detect { |o, _| o.name == "Example Department" }
          expect(example.alternate_name).to eq("EXD")
          expect(example_apis.map(&:name)).to eq(["API One", "API Two"])

          _, other_apis = catalogue.organisations_apis.detect { |o, _| o.name == "Other Department" }
          expect(other_apis.map(&:name)).to eq(["API Three"])
        end
      end

      it "coerces date columns into Date instances" do
        with_csvs(apis_csv, organisations_csv) do |cat_path, org_path|
          catalogue = described_class.from_csv(catalogue_csv: cat_path, organisation_csv: org_path)

          api_one = catalogue.organisations_apis.values.flatten.detect { |a| a.name == "API One" }

          expect(api_one.date_added).to eq(Date.new(2024, 1, 15))
          expect(api_one.date_updated).to eq(Date.new(2024, 2, 1))
          expect(api_one.start_date).to eq(Date.new(2024, 1, 1))
          expect(api_one.end_date).to be_nil
        end
      end

      it "keeps organisations with no published APIs in the grouping with an empty list" do
        orgs = <<~CSV
          id,name,alternateName,url
          empty-dept,Empty Department,ED,https://empty.gov.uk
          example-dept,Example Department,EXD,https://example.gov.uk
        CSV
        apis = <<~CSV
          dateAdded,dateUpdated,url,name,description,documentation,license,maintainer,areaServed,startDate,endDate,provider
          2024-01-15,2024-02-01,https://api.example.gov.uk/one,API One,First API,https://docs/one,MIT,team,UK,,,example-dept
        CSV

        with_csvs(apis, orgs) do |cat_path, org_path|
          catalogue = described_class.from_csv(catalogue_csv: cat_path, organisation_csv: org_path)

          empty_org, empty_apis = catalogue.organisations_apis.detect { |o, _| o.name == "Empty Department" }
          expect(empty_org).not_to be_nil
          expect(empty_apis).to eq([])
        end
      end

      it "drops imported APIs whose provider does not match any organisation" do
        orphan_apis = <<~CSV
          dateAdded,dateUpdated,url,name,description,documentation,license,maintainer,areaServed,startDate,endDate,provider
          2024-01-15,2024-02-01,https://api.example.gov.uk/ghost,Ghost API,Orphan,https://docs/ghost,MIT,team,UK,,,unknown-dept
        CSV

        with_csvs(orphan_apis, organisations_csv) do |cat_path, org_path|
          catalogue = described_class.from_csv(catalogue_csv: cat_path, organisation_csv: org_path)

          expect(catalogue.organisations_apis.values.flatten).to be_empty
          expect(catalogue.organisations_apis.keys).not_to be_empty
        end
      end

      it "produces an empty catalogue when both CSVs contain only headers" do
        empty_apis = "dateAdded,dateUpdated,url,name,description,documentation,license,maintainer,areaServed,startDate,endDate,provider\n"
        empty_orgs = "id,name,alternateName,url\n"

        with_csvs(empty_apis, empty_orgs) do |cat_path, org_path|
          catalogue = described_class.from_csv(catalogue_csv: cat_path, organisation_csv: org_path)

          expect(catalogue.organisations_apis).to eq({})
        end
      end
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

      api_catalogue = described_class.new(apis:, organisations:)
      first_org, first_org_apis = api_catalogue.organisations_apis.first

      expect(first_org.name).to eq "A-Org"
      expect(first_org_apis.map(&:name)).to eq %w[A1 A2]
    end
  end
end
