module GovukTechDocs
  module TableOfContents
    class HeadingsBuilder
      def initialize(html, url)
        @html = html
        @url = url
      end

      def headings
        heading_elements.map do |element|
          Heading.new(
            element_name: element.node_name,
            text: element.content,
            attributes: convert_nokogiri_attr_objects_to_hashes(element.attributes),
            page_url: @url,
          )
        end
      end

    private

      def page
        @page ||= Nokogiri::HTML(@html)
      end

      def heading_elements
        page.search("h1, h2, h3, h4, h5, h6")
      end

      def convert_nokogiri_attr_objects_to_hashes(attributes)
        attributes.tap do |hash|
          hash.each do |k, v|
            hash[k] = v.value
          end
        end
      end
    end
  end
end
