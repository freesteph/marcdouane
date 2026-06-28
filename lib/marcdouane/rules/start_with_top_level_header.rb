# frozen_string_literal: true

module Marcdouane
  module Rules
    # Ensure the first line, frontmatter or not, is a top-level
    # header.
    class StartWithTopLevelHeader < Rule
      ERROR_MESSAGE = "The file should start with a top-level header"

      def check!
        sections = @markdown.chunks_by_heading

        if sections.empty? || sections.first[:level] != 1
          error!(0)
        end
      end
    end
  end
end
