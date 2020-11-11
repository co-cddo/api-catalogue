module GovukTechDocs
  class PageReview
    attr_reader :page

    def initialize(page, config = {})
      @page = page
      @config = config
    end

    def review_by
      return unless last_reviewed_on

      @review_by ||= Chronic.parse(
        "in #{page.data.review_in}",
        now: last_reviewed_on.to_time,
      ).to_date
    end

    def under_review?
      page.data.review_in.present?
    end

    def last_reviewed_on
      page.data.last_reviewed_on
    end

    def owner_slack
      page.data.owner_slack || default_owner_slack
    end

    def owner_slack_url
      return "" unless owner_slack_workspace

      # Slack URLs don't have the # (channels) or @ (usernames)
      slack_identifier = owner_slack.to_s.delete("#").delete("@")
      "https://#{owner_slack_workspace}.slack.com/messages/#{slack_identifier}"
    end

    def show_expiry?
      @config[:tech_docs].fetch(:show_expiry, true)
    end

    def show_review_banner?
      @config[:tech_docs].fetch(:show_review_banner, true)
    end

  private

    def default_owner_slack
      @config[:tech_docs][:default_owner_slack]
    end

    def owner_slack_workspace
      @config[:tech_docs][:owner_slack_workspace]
    end
  end
end
