module GovukTechDocs
  class Redirects
    LEADING_SLASH = %r[\A\/].freeze

    def initialize(context)
      @context = context
    end

    def redirects
      all_redirects = redirects_from_config + redirects_from_frontmatter

      all_redirects.map do |from, to|
        # Middleman needs paths without leading slashes
        [from.sub(LEADING_SLASH, ""), to: to.sub(LEADING_SLASH, "")]
      end
    end

  private

    attr_reader :context

    def redirects_from_config
      context.config[:tech_docs][:redirects].to_a
    end

    def redirects_from_frontmatter
      reds = []
      context.sitemap.resources.each do |page|
        next unless page.data.old_paths

        page.data.old_paths.each do |old_path|
          reds << [old_path, page.path]
        end
      end

      reds
    end
  end
end
