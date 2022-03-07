require_relative "fetcher"

class V1AlphaFetcher < Fetcher
  def fetch(base_url)
    base_url += "/apis"

    uri = URI(base_url)

    req = Net::HTTP::Get.new(uri)
    req["correlation-id"] = SecureRandom.uuid
    req["accept"] = "application/vnd.uk.gov.api.v1alpha+json"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(req)
    end
    raise VersionNotSupportedError, "Could not parse APIs from #{base_url}, no version supported" if response.is_a? Net::HTTPNotAcceptable

    raise VersionNotSupportedError, "A client error caused retrieval of APIs from #{base_url} to fail" if response.is_a? Net::HTTPNotFound

    raise TemporaryError, "A temporary error caused retrieval of APIs from #{base_url} to fail" if response.is_a? Net::HTTPServerError

    raise ClientError, "Bad request returned by #{base_url}, could be contract issue?" if response.is_a? Net::HTTPBadRequest

    response = JSON.parse response.body

    apis = response["apis"].map do |api|
      data = api["data"]
      Api.new name: data["name"],
              description: data["description"],
              url: data["url"],
              documentation: data["documentation-url"],
              provider: create_organisation_id(data["organisation"]),
              maintainer: data["contact"]
    end

    orgs = response["apis"].map do |api|
      create_organisation(api["data"]["organisation"])
    end

    ApiCatalogue.new apis: apis, organisations: orgs
  end

  def create_organisation(name)
    id = create_organisation_id(name)
    alternate_name = if name.match(/\s/)
                       name.slice! "and "
                       name.split(/[ \-]/).map(&:first).join.downcase
                     else
                       name
                     end
    Organisation.new id: id, name: name, alternate_name: alternate_name
  end

  def create_organisation_id(name)
    name.gsub(/\s+/, "-").downcase
  end
end
