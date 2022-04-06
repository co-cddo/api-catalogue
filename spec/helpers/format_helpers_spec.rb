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

  describe "#convert_newlines_to_spaces" do
    it "converts escaped newlines into spaces" do
      original = 'foo\nbar\nbaz\n'

      expect(helpers.convert_newlines_to_spaces(original)).to eq 'foo bar baz '
    end
  end

  describe "#text_snippet" do
    it "returns the first full sentences up to 300 characters" do
      description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi nulla elit, sodales eu turpis tristique, pharetra suscipit neque. Quisque euismod eleifend odio, sed tincidunt magna fermentum id. Suspendisse eu nulla nec nisl rhoncus porttitor. Morbi at tortor sed orci tempus volutpat. In accumsan non ex aliquet fermentum. Aliquam vehicula purus sit amet ornare porttitor. Duis mollis nunc a diam ornare blandit. Pellentesque placerat interdum lacus sed lobortis. Sed consectetur ornare magna, id sodales nulla efficitur a. Phasellus sed fringilla felis. Vivamus vel purus vel lorem pulvinar tincidunt."

      expect(helpers.text_snippet(description)).to eq("<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi nulla elit, sodales eu turpis tristique, pharetra suscipit neque. Quisque euismod eleifend odio, sed tincidunt magna fermentum id. Suspendisse eu nulla nec nisl rhoncus porttitor. Morbi at tortor sed orci tempus volutpat.</p>\n")
    end

    it "returns the first sentence if less than 211 characters" do
      description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."

      expect(helpers.text_snippet(description)).to eq("<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>\n")
    end

    it "returns nil if first sentence is more than 300 characters" do
      description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, morbi nulla elit, sodales eu turpis tristique, pharetra suscipit neque, quisque euismod eleifend odio, sed tincidunt magna fermentum id, suspendisse eu nulla nec nisl rhoncus porttitor, morbi at tortor sed orci tempus volutpat, in accumsan non ex aliquet fermentum, aliquam vehicula purus sit amet ornare porttitor, duis mollis nunc a diam ornare blandit, pellentesque placerat interdum lacus sed lobortis, sed consectetur ornare magna, id sodales nulla efficitur a, phasellus sed fringilla felis. Vivamus vel purus vel lorem pulvinar tincidunt."

      expect(helpers.text_snippet(description)).to eq(nil)
    end

    it "works" do
      description = "GOV.UK Notify allows government departments to send emails, text messages and letters to their users.\n\nThe API contains:\n\n- the public-facing REST API for GOV.UK Notify, which teams can integrate with using our clients\n- an internal-only REST API built using Flask to manage services, users, templates, etc (this is what the admin app talks to)\n- asynchronous workers built using Celery to put things on queues and read them off to be processed, sent to providers, updated, etc"

      expect(helpers.text_snippet(description)).to eq("<p>GOV.UK Notify allows government departments to send emails, text messages and letters to their users.</p>\n")
    end

    it "police works" do
      description = "The API provides a rich data source for information, including:\n\n- neighbourhood team members\n- upcoming events\n- street-level crime and outcome data\n- nearest police stations\n\nThe API is implemented as a standard JSON web service using HTTP GET and POST requests. Full request and response examples are provided in the documentation."

      expect(helpers.text_snippet(description)).to eq(nil)
    end
  end

  describe "#handle_lists" do
    it "returns nil if there is a list without a full sentence before it" do
      description = "Lorem ipsum dolor sit amet:\n- consectetur adipiscing elit\n- morbi nulla elit, sodales eu turpis tristique\n-  pharetra suscipit neque"

      expect(helpers.handle_lists(description)).to eq(nil)
    end

    it "returns the first sentence if there is a sentence before a list" do
      description = "In hac habitasse platea dictumst. Lorem ipsum dolor sit amet:\n- consectetur adipiscing elit\n- morbi nulla elit, sodales eu turpis tristique\n-  pharetra suscipit neque"

      expect(helpers.handle_lists(description)).to eq("In hac habitasse platea dictumst.")
    end

    it "returns the first sentence if there is a full sentence followed by a newline before a list" do
      description = "GOV.UK Notify allows government departments to send emails, text messages and letters to their users.\n\nThe API contains:\n\n- the public-facing REST API for GOV.UK Notify, which teams can integrate with using our clients\n- an internal-only REST API built using Flask to manage services, users, templates, etc (this is what the admin app talks to)\n- asynchronous workers built using Celery to put things on queues and read them off to be processed, sent to providers, updated, etc"

      expect(helpers.handle_lists(description)).to eq("GOV.UK Notify allows government departments to send emails, text messages and letters to their users.")
    end
  end
end
