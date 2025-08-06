require "lib/api_catalogue_overview"
require "lib/api_catalogue"
require "lib/dashboard_stats"
require "lib/url_helpers"
require "lib/links"
require "lib/provider"

### Config from tech-docs-gem: start ###
require "middleman"
require "middleman-autoprefixer"
require "middleman-sprockets"
require "middleman-livereload"
require "middleman-search"

require "active_support/all"

require "lib/govuk_tech_docs/contribution_banner"
require "lib/govuk_tech_docs/meta_tags"
require "lib/govuk_tech_docs/tech_docs_html_renderer"
require "lib/govuk_tech_docs/unique_identifier_extension"
require "lib/govuk_tech_docs/unique_identifier_generator"

activate :sprockets

sprockets.append_path File.expand_path("node_modules", __dir__)

files.watch :source, path: File.expand_path("source", __dir__)

set :markdown_engine, :redcarpet
set :markdown,
    renderer: GovukTechDocs::TechDocsHTMLRenderer.new(
      with_toc_data: true,
      context: self,
    ),
    fenced_code_blocks: true,
    tables: true,
    no_intra_emphasis: true

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

configure :build do
  activate :autoprefixer
  activate :minify_javascript, ignore: ["/raw_assets/*"]
end

config_file = ENV.fetch("CONFIG_FILE", "config/tech-docs.yml")
config[:tech_docs] = YAML.load_file(config_file).with_indifferent_access
activate :unique_identifier

redirect "security.txt/index.html", to: "https://vdp.cabinetoffice.gov.uk/.well-known/security.txt"
redirect ".well-known/security.txt/index.html", to: "https://vdp.cabinetoffice.gov.uk/.well-known/security.txt"
import_file File.expand_path("_config.yml", config[:source]), "/_config.yml"

helpers do
  include GovukTechDocs::ContributionBanner

  def meta_tags
    @meta_tags ||= GovukTechDocs::MetaTags.new(config, current_page)
  end

  def format_date(date)
    date.strftime("%-e %B %Y")
  end

  def active_page(page_path)
    [
      page_path == "/" && current_page.path == "index.html",
      "/#{current_page.path}" == page_path,
      !current_page.data.parent.nil? && current_page.data.parent.to_s == page_path,
    ].any?
  end

  def links
    links_csv = File.expand_path("data/links.csv", __dir__)
    Links.from_csv(links_csv)
  end
end

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

activate :search do |search|
  search.resources = [""]

  search.fields = {
    title: { boost: 100, store: true, required: true },
    content: { boost: 50, store: true },
    url: { index: false, store: true },
  }

  search.pipeline_remove = %w[stopWordFilter]

  search.tokenizer_separator = '/[\s\-/]+/'
end
### Config from tech-docs-gem: end ###

helpers UrlHelpers

catalogue_csv = File.expand_path("data/catalogue.csv", __dir__)
organisation_csv = File.expand_path("data/organisation.csv", __dir__)
static = ApiCatalogue.from_csv(catalogue_csv:, organisation_csv:)
api_catalogue = ApiCatalogue.merge([static])

# Order organisations from A-Z in the Table of Contents,
# leaving a buffer from 0-999 for static content to be given priority
initial_org_weight = 1_000

api_catalogue.organisations_apis.each.with_index(initial_org_weight) do |(organisation, apis), org_weight|
  proxy(
    UrlHelpers.organisation_path(organisation),
    "organisation_index.html",
    locals: { organisation:, apis: },
    data: {
      title: organisation.name,
      weight: org_weight,
    },
    ignore: true,
  )

  apis.each_with_index do |api, api_weight|
    proxy(
      UrlHelpers.api_path(organisation:, api:),
      "api_details.html",
      locals: { api: },
      data: {
        title: api.name,
        weight: api_weight,
      },
      ignore: true,
    )
  end
end

proxy(
  "/dashboard/index.html",
  "dashboard.html",
  locals: { dashboard_stats: DashboardStats.new(api_catalogue) },
  ignore: true,
)

proxy(
  "/index/index.html",
  "overview_index.html",
  locals: { overview: ApiCatalogueOverview.new(api_catalogue) },
  ignore: true,
)

after_build do |builder|
  apis = File.join(config[:source], "apis")
  builder.thor.source_paths << File.dirname(__FILE__)
  builder.thor.remove_file(apis)
end
