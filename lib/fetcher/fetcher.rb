class Fetcher
  def fetch(_base_url)
    raise VersionNotSupportedError
  end
end

class VersionNotSupportedError < StandardError
end

class TemporaryError < StandardError
end

class ClientError < StandardError
end
