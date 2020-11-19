module GovukTechDocs
  module TableOfContents
    class HeadingTree
      attr_accessor :parent, :heading, :children

      def initialize(parent: nil, heading: nil, children: [])
        @parent = parent
        @heading = heading
        @children = children
      end

      def depth
        if parent
          parent.depth + 1
        else
          1
        end
      end

      def ==(other)
        heading == other.heading &&
          children.length == other.children.length &&
          children.map.with_index { |child, index| child == other.children[index] }.all?
      end
    end
  end
end
