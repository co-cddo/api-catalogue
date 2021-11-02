xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = config[:tech_docs][:host]
  xml.title "UK Government API and Data Exchange Community Slack Community Links"
  xml.subtitle "Links of interest, being discussed by the UK Government API Community on https://ukgovtapidx.slack.com/"
  xml.link "href" => URI.join(site_url, current_page.path), "rel" => "self"
  xml.updated(links.links.first.date_added.to_time.iso8601) unless links.links
  xml.author do
    xml.name "UK Government API Community"
    xml.uri config[:tech_docs][:host]
    xml.email "api-programme@digital.cabinet-office.gov.uk"
  end

  links.links.each do |link|
    tracking_url = append_querystring(link.url, {
      utm_source: "api.gov.uk",
      utm_medium: "rss",
    })
    content = <<-DOC
    <a href="#{tracking_url}">#{link.url}</a> was shared in the <a href="https://ukgovtapidx.slack.com/">UK Government API and Data Exchange Community Slack</a>
    DOC
    xml.entry do
      xml.title link.title
      xml.link "rel" => "alternate", "href" => link.url
      xml.id link.url
      xml.published link.date_added.to_time.iso8601
      xml.content content, "type" => "html"
    end
  end
end
