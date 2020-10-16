require_relative "../../helpers/format_helpers"

RSpec.describe FormatHelpers do
  subject(:helpers) do
    Class.new { include FormatHelpers }.new
  end

  describe "#render_markdown" do
    it "renders HTML from the markdown content" do
      markdown = "Some content"

      expect(helpers.render_markdown(markdown)).to match "<p>Some content</p>"
    end

    it "autolinks any URLs which aren't normal markdown links" do
      markdown = "Checkout https://example.com"

      expect(helpers.render_markdown(markdown))
        .to match '<p>Checkout <a href="https://example.com">https://example.com</a></p>'
    end
  end

  describe "#unescape_newlines" do
    it "converts escaped newlines into unescaped, literal newlines" do
      original = 'foo\nbar\n\nbaz\n'

      expect(helpers.unescape_newlines(original)).to eq <<~TXT
        foo
        bar

        baz
      TXT
    end
  end
end
