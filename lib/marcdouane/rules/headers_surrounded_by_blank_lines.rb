# frozen_string_literal: true

module Marcdouane
  module Rules
    # Ensure all headers sit between blank lines, except the first one
    # and possibly the last one.
    class HeadersSurroundedByBlankLines < Rule
      ERROR_MESSAGE = "Headers should be surrounded by blank lines"

      def check!
        @markdown.on(:heading) do |header|
          line_no = line_number_from_byte_range(header.byte_range)

          error!(line_no) unless next_line_blank?(line_no) && previous_line_blank?(line_no)
        end

        @markdown.walk
      end

      def next_line_blank?(line_no)
        if line_no < @source.lines.length - 1
          blank?(@source.lines[line_no + 1])
        else
          true
        end
      end

      def previous_line_blank?(line_no)
        if line_no > 0 # rubocop:disable Style/NumericPredicate
          blank?(@source.lines[line_no - 1])
        else
          true
        end
      end

      def blank?(str)
        str.match?(/^\s+$/) # FIXME: no trailing whitespace would make this \s
      end
    end
  end
end
