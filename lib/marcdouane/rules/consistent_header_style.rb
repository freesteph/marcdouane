# frozen_string_literal: true

module Marcdouane
  module Rules
    class ConsistentHeaderStyle < Rule
      ERROR_MESSAGE = "Use a unique, consistent header style"

      def check!
        reference_style, style = nil

        source = @markdown.source.lines.dup

        @markdown.on(:heading) do |header|
          line_number = line_number_from_byte_range(header.byte_range)

          raw_line = source[line_number]

          if raw_line.start_with?("#")
            style = :normal
          else
            style = :underline
          end

          reference_style ||= style

          if reference_style != style
            error!(line_number)
          end
        end

        @markdown.walk
      end
    end
  end
end
