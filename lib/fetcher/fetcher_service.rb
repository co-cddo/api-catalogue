class FetcherService
  def initialize(fetchers)
    @fetchers = fetchers
  end

  def self.instance
    FetcherService.new([V1AlphaFetcher.new])
  end

  def fetch(url)
    @fetchers.each do |fetcher|
      return fetcher.fetch(url)
    rescue VersionNotSupportedError
      # Ignore as we're happy with the version not being supported, as others may be supported
    end
    raise ClientError
  end
end
