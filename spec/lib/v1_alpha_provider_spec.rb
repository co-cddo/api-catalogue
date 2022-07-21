require "provider"
require "organisation"
require "api_catalogue"

RSpec.describe V1AlphaProvider do
  describe "::retrieve_all" do
    it "returns all the APIs" do
      api_one = Api.new name: "Test API One", description: "First test API", url: "example1.com", maintainer: "test@example1.com", documentation: "example1.com/docs", provider: "test-org-one"
      api_two = Api.new name: "Test API Two", description: "Second test API", url: "example2.com", maintainer: "test@example2.com", documentation: "example2.com/docs", provider: "test-org-one"
      org_one = Organisation.new id: "test-org-one", name: "Test Org One"
      catalogue_one = ApiCatalogue.new(apis: [api_one, api_two], organisations: [org_one])

      result = JSON.parse(described_class.retrieve_all([catalogue_one]))

      expected = JSON.parse(File.read("spec/lib/test_data/all_apis.json"))

      expect(result).to eq expected
    end

    it "returns all the APIs from multiple catalogues" do
      api_one = Api.new name: "Test API One", description: "First test API", url: "example1.com", maintainer: "test@example1.com", documentation: "example1.com/docs", provider: "test-org-one"
      api_two = Api.new name: "Test API Two", description: "Second test API", url: "example2.com", maintainer: "test@example2.com", documentation: "example2.com/docs", provider: "test-org-one"
      org_one = Organisation.new id: "test-org-one", name: "Test Org One"
      api_three = Api.new name: "Test API Three", description: "Third test API", url: "example3.com", maintainer: "test@example3.com", documentation: "example3.com/docs", provider: "test-org-two"
      org_two = Organisation.new id: "test-org-two", name: "Test Org Two"
      catalogue_one = ApiCatalogue.new(apis: [api_one, api_two], organisations: [org_one])
      catalogue_two = ApiCatalogue.new(apis: [api_three], organisations: [org_two])

      result = JSON.parse(described_class.retrieve_all([catalogue_one, catalogue_two]))

      expected = JSON.parse(File.read("spec/lib/test_data/all_apis_multiple_catalogues.json"))

      expect(result).to eq expected
    end
  end
end
