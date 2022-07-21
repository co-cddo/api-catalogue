class V1AlphaProvider
  def self.retrieve_all(api_catalogues)
    all_apis = []
    api_catalogues.each do |catalogue|
      catalogue.organisations_apis.each do |org, apis|
        apis.each do |api|
          metadata = {
            "api-version": "api.gov.uk/v1alpha",
            "data": {
              "name": api.name,
              "description": api.description,
              "url": api.url,
              "contact": api.maintainer,
              "organisation": org.name,
              "documentation-url": api.documentation,
            },
          }

          all_apis.append(metadata)
        end
      end
    end
    { "api-version" => "api.gov.uk/v1alpha", "apis" => all_apis }.to_json
  end
end
