require "api_catalogue"

RSpec.describe ApiCatalogue, "::from_csv" do
  let(:csv_path) { File.expand_path("../../data/inputs/apic.csv", __dir__) }

  it "parses the CSV source" do
    api_catalogue = described_class.from_csv(csv_path)

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
