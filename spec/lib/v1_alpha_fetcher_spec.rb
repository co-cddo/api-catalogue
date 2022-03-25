require "api_catalogue"
require "webmock/rspec"

RSpec.describe V1AlphaFetcher do
  let(:v1_alpha_fetcher) { described_class.new }

  describe "#fetch" do
    describe "success" do
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
              contact: "Test Contact",
            },
          ],
        }

        stub_request(:get, "http://localhost/subpath/apis")
          .with(headers: { "correlation-id" => /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-4[a-fA-F0-9]{3}-[89abAB][a-fA-F0-9]{3}-[a-fA-F0-9]{12}/, "accept" => "application/vnd.uk.gov.api.v1alpha+json" })
          .to_return(status: 200, body: apis_response.to_json)
      end

      it "parses APIs" do
        api_catalogue = v1_alpha_fetcher.fetch "http://localhost/subpath"

        expect(api_catalogue.organisations_apis.size).to eq(1)

        _, org_apis = api_catalogue.organisations_apis.detect do |org, _|
          org.name.casecmp?("Test Org")
        end

        test_api = org_apis.detect do |api|
          api.name.casecmp?("test API")
        end

        expect(test_api).to have_attributes(
          name: "test API",
          description: "test description",
          url: "www.foo.bar",
          documentation: "www.docs.foo.bar",
          provider: "test-org",
          maintainer: "Test Contact",
        )
      end
    end

    describe "not accepted" do
      it "raises NoVersionAcceptable" do
        stub_request(:get, "http://localhost/subpath/apis")
          .to_return(status: 406)

        expect { v1_alpha_fetcher.fetch "http://localhost/subpath" }.to raise_error("Could not parse APIs from http://localhost/subpath/apis, no version supported")
      end
    end

    describe "not found" do
      it "raises NoVersionFound" do
        stub_request(:get, "http://localhost/subpath/apis")
          .to_return(status: 404)

        expect { v1_alpha_fetcher.fetch "http://localhost/subpath" }.to raise_error("A client error caused retrieval of APIs from http://localhost/subpath/apis to fail")
      end
    end

    describe "temporary error" do
      it "raises TemporaryError" do
        stub_request(:get, "http://localhost/subpath/apis")
          .to_return(status: 500)

        expect { v1_alpha_fetcher.fetch "http://localhost/subpath" }.to raise_error("A temporary error caused retrieval of APIs from http://localhost/subpath/apis to fail")
      end
    end

    describe "bad request" do
      it "raises ClientError" do
        stub_request(:get, "http://localhost/subpath/apis")
          .to_return(status: 400)

        expect { v1_alpha_fetcher.fetch "http://localhost/subpath" }.to raise_error("Bad request returned by http://localhost/subpath/apis, could be contract issue?")
      end
    end

    describe "::create_organisation" do
      it "creates an id using a camel case, lowercase version of the name" do
        name = "Test Organisation"
        organisation = v1_alpha_fetcher.create_organisation(name)

        expect(organisation.id).to eq "test-organisation"
      end

      it "creates a contraction for the alternative name if it contains multiple words" do
        name = "Test Organisation"
        organisation = v1_alpha_fetcher.create_organisation(name)

        expect(organisation.alternate_name).to eq "to"
      end

      it "uses the name for the alternative name if it's a single word" do
        name = "Test"
        organisation = v1_alpha_fetcher.create_organisation(name)

        expect(organisation.alternate_name).to eq "Test"
      end

      it "removes the word 'and' from alternative name to create the contracted version" do
        name = "Central Digital and Data Office"
        organisation = v1_alpha_fetcher.create_organisation(name)

        expect(organisation.alternate_name).to eq "cddo"
      end

      it "doesn't remove the word 'and' from the full name after creating the contracted version" do
        name = "Central Digital and Data Office"
        organisation = v1_alpha_fetcher.create_organisation(name)

        expect(organisation.name).to eq "Central Digital and Data Office"
      end
    end
  end
end
