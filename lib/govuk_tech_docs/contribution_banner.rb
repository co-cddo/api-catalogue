module GovukTechDocs
  # Helper included
  module ContributionBanner
    def source_urls
      SourceUrls.new(current_page, config)
    end
  end

  class SourceUrls
    attr_reader :current_page, :config

    def initialize(current_page, config)
      @current_page = current_page
      @config = config
    end

    def view_source_url
      override_from_page || source_from_yaml_file || source_from_file
    end

    def report_issue_url
      url = config[:source_urls]&.[](:report_issue_url)

      if url.nil?
        "#{repo_url}/issues/new?labels=bug&title=Re: '#{current_page.data.title}'&body=Problem with '#{current_page.data.title}' (#{config[:tech_docs][:host]}#{current_page.url})"
      else
        "#{url}?subject=Re: '#{current_page.data.title}'&body=Problem with '#{current_page.data.title}' (#{config[:tech_docs][:host]}#{current_page.url})"
      end
    end

    def repo_url
      "https://github.com/#{config[:tech_docs][:github_repo]}"
    end

    def repo_branch
      config[:tech_docs][:github_branch] || "master"
    end

  private

    # If a `page` local exists, see if it has a `source_url`. This is used by the
    # pages that are created by the proxy system because they can't use frontmatter
    def override_from_page
      locals.key?(:page) ? locals[:page].try(:source_url) : false
    end

    # In the frontmatter we can specify a `source_url`. Use this if the actual
    # source of the page is in another GitHub repo.
    def source_from_yaml_file
      current_page.data.source_url
    end

    # As the last fallback link to the source file in this repository.
    def source_from_file
      "#{repo_url}/blob/#{repo_branch}/source/#{current_page.file_descriptor[:relative_path]}"
    end

    def locals
      current_page.metadata[:locals]
    end
  end
end
