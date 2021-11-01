require "url_helpers"

RSpec::Matchers.define :have_same_querystring do |expected|
  match do |actual|
    CGI.parse(URI.parse(expected).query) == CGI.parse(URI.parse(actual).query)
  end
end

RSpec.describe "UrlHelpers" do
  describe "append_querystring" do
    [nil, "", "http", "https://foo&bar=baz"].each do |_value|
      it "does not support invalid URIs" do
        expect { UrlHelpers.append_querystring(nil, nil) }.to raise_error(URI::InvalidURIError)
      end
    end

    it "creates querystring if not present" do
      url = "https://url"
      to_add = {
        utm: "foo",
      }
      expect(UrlHelpers.append_querystring(url, to_add)).to have_same_querystring "https://url?utm=foo"
    end

    it "appends to existing querystring if present" do
      url = "https://blog?post=1234"
      to_add = {
        add: "foo",
      }
      expect(UrlHelpers.append_querystring(url, to_add)).to have_same_querystring "https://blog?add=foo&post=1234"
    end

    it "ignores everything but the first querystring parameter" do
      url = "https://blog?foo=1234&foo=2345"
      to_add = {
        add: "foo",
      }
      expect(UrlHelpers.append_querystring(url, to_add)).to have_same_querystring "https://blog?add=foo&foo=1234"
    end

    it "doesn't require query to override" do
      url = "https://blog?foo=1234"
      expect(UrlHelpers.append_querystring(url, {})).to have_same_querystring url
    end
  end
end
