module UrlHelpers
  def organisation_path(organisation)
    "/#{organisation.slug}/index.html"
  end
  module_function :organisation_path

  def api_path(organisation:, api:)
    "/#{organisation.slug}/#{api.slug}/index.html"
  end
  module_function :api_path
end
