module GovukTechDocs
  module TableOfContents
    class HeadingTreeBuilder
      def initialize(headings)
        @headings = headings
        @tree = HeadingTree.new
        @pointer = @tree
      end

      def tree
        @headings.each do |heading|
          move_to_depth(heading.size)

          @pointer.children << HeadingTree.new(parent: @pointer, heading: heading)
        end

        @tree
      end

    private

      def move_to_depth(depth)
        if depth > @pointer.depth
          @pointer = @pointer.children.last

          if depth > @pointer.depth
            @pointer.children << HeadingTree.new(parent: @pointer)

            move_to_depth(depth)
          end
        end

        if depth < @pointer.depth
          @pointer = @pointer.parent

          move_to_depth(depth)
        end
      end
    end
  end
end
