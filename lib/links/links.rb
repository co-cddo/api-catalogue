require_relative "link"
require_relative "../csv_source"

class Links
  def self.from_csv(links_csv)
    links = CsvSource.load(links_csv) { |attributes| Link.new(attributes) }
    new(links)
  end

  attr_reader :links, :all_links

  def initialize(links)
    @links = links.select(&:valid?)
    @all_links = links
  end

  def by_date
    links.group_by(&:date_added)
  end
end
