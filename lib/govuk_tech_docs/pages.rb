module GovukTechDocs
  class Pages
    attr_reader :sitemap

    def initialize(sitemap, config)
      @sitemap = sitemap
      @config = config
    end

    def to_json(*_args)
      as_json.to_json
    end

  private

    def as_json
      pages.map do |page|
        review = PageReview.new(page, @config)
        {
          title: page.data.title,
          url: "#{@config[:tech_docs][:host]}#{page.url}",
          review_by: review.review_by,
          owner_slack: review.owner_slack,
        }
      end
    end

    def pages
      sitemap.resources.select { |page| page.data.title }
    end
  end
end
