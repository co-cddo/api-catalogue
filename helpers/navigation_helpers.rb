module NavigationHelpers
  def render_sidebar(resources)
    root_page = resources.detect { |r| r.path == "index.html" }
    top_level_pages = navigable_pages(root_page.children).sort_by { |page| page.data.weight || 99_999 }
    navigation = []

    navigation << navigation_html(root_page)
    navigation += top_level_pages.map { |page| navigation_html_with_subpages(page) }
    navigation.join
  end

private

  def navigable_pages(resources)
    resources
      .filter { |resource| resource.ext.match?("html") }
      .reject { |resource| resource.data.hide_in_navigation }
  end

  def navigation_html(page)
    <<~HTML
      <ul>
        <li>
          <a href="#{page.url}"><span>#{page.data.title}</span></a>
          #{yield if block_given?}
        </li>
      </ul>
    HTML
  end

  def navigation_html_with_subpages(page)
    nested_navigation = nil
    navigable_children = navigable_pages(page.children)

    if navigable_children.any?
      nested_navigation = navigable_children
        .map { |child_page| navigation_html(child_page) }
        .join
    end

    navigation_html(page) { nested_navigation }
  end
end
