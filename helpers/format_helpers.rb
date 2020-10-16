require "redcarpet"

module FormatHelpers
  def render_markdown(content)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
      .render(content)
  end

  # Converts escaped newlines into literal newlines ("\\n" => "\n")
  def unescape_newlines(content)
    content.gsub('\n', "\n")
  end
end
