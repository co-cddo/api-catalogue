require "singleton"

module GovukTechDocs
  class UniqueIdentifierGenerator
    include Singleton

    Anchor = Struct.new(:id, :level)

    attr_reader :anchors

    def initialize
      reset
    end

    def create(id, level)
      anchor = heading_slug(id)

      unless unique?(anchor)
        anchor = prefixed_by_parent(anchor, level)
      end

      unless unique?(anchor)
        anchor = suffixed_with_number(anchor)
      end

      @anchors << Anchor.new(anchor, level)

      anchor
    end

    def reset
      @anchors = []
    end

  private

    def prefixed_by_parent(anchor, level)
      closest_parent = @anchors.reverse.find { |a| a.level < level }
      if closest_parent.nil?
        anchor
      else
        [closest_parent.id, anchor].join("-")
      end
    end

    def suffixed_with_number(text)
      number = 2
      anchor = "#{text}-#{number}"

      until unique?(anchor)
        anchor = "#{text}-#{number}"
        number += 1
      end

      anchor
    end

    def unique?(value)
      @anchors.none? { |a| a.id == value }
    end

    # https://github.com/vmg/redcarpet/blob/820dadb98b3720811cc20c5570a5d43c796c85fc/ext/redcarpet/html.c#L274-L305
    def heading_slug(text)
      text
        .downcase
        .strip
        .gsub(%r{</?[^>]+?>}, "") # Remove HTML tags
        .gsub(/[^0-9a-z]+/, "-")  # Replace non-alphanumeric characters with dashes
        .gsub(/\A-+|-+\z/, "")    # Remove trailing dashes
    end
  end
end
