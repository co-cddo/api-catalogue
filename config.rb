require 'govuk_tech_docs'
require 'lib/api_catalogue'

GovukTechDocs.configure(self)

# use relative paths for links and sources
activate :relative_assets
set :relative_links, true

csv_path = File.expand_path("data/inputs/apic.csv", __dir__)

ApiCatalogue.from_csv(csv_path).organisations_apis.each do |organisation, apis|
  proxy(
    "/#{organisation.slug}/index.html",
    "organisation_index.html",
    locals: { organisation: organisation, apis: apis },
    data: { title: organisation.name },
    ignore: true,
  )

  apis.each do |api|
    proxy(
      "/#{organisation.slug}/#{api.slug}/index.html",
      "api_details.html",
      locals: { api: api },
      data: { title: api.name },
      ignore: true,
    )
  end
end
