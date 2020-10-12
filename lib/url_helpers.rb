module UrlHelpers
module_function

  def organisation_path(organisation)
    "/#{organisation.slug}/index.html"
  end

  def api_path(organisation:, api:)
    "/#{organisation.slug}/#{api.slug}/index.html"
  end
end
