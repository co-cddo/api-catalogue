module GovukTechDocs
  module TableOfContents
    class HeadingTreeRenderer
      DEFAULT_MAX_LEVEL = Float::INFINITY
      DEFAULT_INDENTATION = "".freeze
      INDENTATION_INCREMENT = "  ".freeze

      def initialize(heading_tree, max_level: nil)
        @heading_tree = heading_tree
        @max_level = max_level || DEFAULT_MAX_LEVEL
      end

      def html
        render_tree(@heading_tree, level: 0)
      end

    private

      def render_tree(tree, indentation: DEFAULT_INDENTATION, level: nil)
        output = ""

        if tree.heading
          output += indentation + %{<a href="#{tree.heading.href}"><span>#{tree.heading.title}</span></a>\n}
        end

        if tree.children.any? && level < @max_level
          output += indentation + "<ul>\n"

          tree.children.each do |child|
            output += indentation + INDENTATION_INCREMENT + "<li>\n"
            output += render_tree(
              child,
              indentation: indentation + INDENTATION_INCREMENT * 2,
              level: level + 1,
            )
            output += indentation + INDENTATION_INCREMENT + "</li>\n"
          end

          output += indentation + "</ul>\n"
        end

        output
      end
    end
  end
end
