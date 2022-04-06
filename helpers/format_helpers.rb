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

  def convert_newlines_to_spaces(content)
    content.gsub('\n', " ")
  end

  def text_snippet(content)
    if content.size < 300
      content = handle_lists(content)
      render_markdown(convert_newlines_to_spaces(content))
    else
      snippet = content[0, 300]
      snippet = handle_lists(snippet)

      if snippet.nil?
        return nil
      end

      if snippet.include? ". "
        snippet = snippet[0...snippet.rindex(". ") + 1]
      elsif snippet.include? ".\n"
        snippet = snippet[0...snippet.rindex(".\n") + 1]
      elsif snippet.include? "."
        snippet = snippet[0...snippet.rindex(".") + 1]
      else
        return nil
      end
      render_markdown(convert_newlines_to_spaces(snippet))
    end
  end

  def handle_lists(content)
    if content.include? "\n-"
      if content[0, content.index("\n-")].include? ". "
        content[0, content.index(". ") + 1]
      elsif content[0, content.index("\n-")].include? ".\n"
        content[0, content.index(".\n") + 1]
      elsif content[0, content.index("\n-")].include? ".\\n"
        content[0, content.index(".\\n") + 1]
      end
    else
      content
    end
  end
end
