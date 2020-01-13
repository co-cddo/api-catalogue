require 'govuk_tech_docs'

GovukTechDocs.configure(self)

# use relative paths for links and sources
activate :relative_assets
set :relative_links, true
set :http_prefix, "/api-catalogue/"
