require_relative "heading_tree_builder"
require_relative "heading_tree_renderer"
require_relative "heading_tree"
require_relative "heading"
require_relative "headings_builder"

module GovukTechDocs
  module TableOfContents
    module Helpers
      def single_page_table_of_contents(html, url: "", max_level: nil)
        headings = HeadingsBuilder.new(html, url).headings

        if headings.none? { |heading| heading.size == 1 }
          raise "No H1 tag found. You have to at least add one H1 heading to the page: " + url
        end

        tree = HeadingTreeBuilder.new(headings).tree
        HeadingTreeRenderer.new(tree, max_level: max_level).html
      end

      def multi_page_table_of_contents(resources, current_page, config, current_page_html = nil)
        # Determine
        home_url =
          if config[:http_prefix].end_with?("/")
            config[:http_prefix]
          else
            config[:http_prefix] + "/"
          end

        # Only parse top level html files
        # Sorted by weight frontmatter
        resources = resources
        .select { |r| r.path.end_with?(".html") && (r.parent.nil? || r.parent.url == home_url) }
        .sort_by { |r| [r.data.weight ? 0 : 1, r.data.weight || 0] }

        render_page_tree(resources, current_page, config, current_page_html)
      end

      def render_page_tree(resources, current_page, config, current_page_html)
        # Sort by weight frontmatter
        resources = resources
        .sort_by { |r| [r.data.weight ? 0 : 1, r.data.weight || 0] }
        output = "";
        resources.each do |resource|
          # Skip from page tree if hide_in_navigation:true frontmatter
          next if resource.data.hide_in_navigation

          # Reuse the generated content for the active page
          # If we generate it twice it increments the heading ids
          content = if current_page.url == resource.url && current_page_html
                      current_page_html
                    else
                      resource.render(layout: false)
                    end
          # Avoid redirect pages
          next if content.include? "http-equiv=refresh"

          # If this page has children, just print the title and recursively
          # render the children. If not, print the heading structure.

          # We avoid printing the children of the root index.html as it is the
          # parent of every other top level file.  We need to take any custom
          # prefix in to consideration when checking for the root index.html.
          # The prefix may be set with or without a trailing slash: make sure
          # it has one for this comparison check.
          home_url =
            if config[:http_prefix].end_with?("/")
              config[:http_prefix]
            else
              config[:http_prefix] + "/"
            end

          if resource.children.any? && resource.url != home_url
            output += %{<ul><li><a href="#{resource.url}"><span>#{resource.data.title}</span></a>\n}
            output += render_page_tree(resource.children, current_page, config, current_page_html)
            output += "</li></ul>"
          else
            output +=
              single_page_table_of_contents(
                content,
                url: resource.url,
                max_level: config[:tech_docs][:max_toc_heading_level],
              )
          end
        end
        output
      end
    end
  end
end
