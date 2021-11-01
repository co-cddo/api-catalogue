module UrlHelpers
module_function

  def organisation_path(organisation)
    "/#{organisation.slug}/index.html"
  end

  def api_path(organisation:, api:)
    "/#{organisation.slug}/#{api.slug}/index.html"
  end

  def append_querystring(uri, add)
    parsed = URI.parse(uri)
    qs = query_to_hash(parsed.query)
    qs.merge!(add)
    parsed.query = URI.encode_www_form(qs)
    parsed.to_s
  end

  def query_to_hash(query)
    return {} unless query

    CGI.parse(query).transform_values(&:first)
  end
end
