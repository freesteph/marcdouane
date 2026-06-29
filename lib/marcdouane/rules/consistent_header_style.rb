# frozen_string_literal: true

module Marcdouane
  module Rules
    # Ensure that headers style is consistent: either the '#'-prefix
    # style or the '=' underscore style, but not both.
    class ConsistentHeaderStyle < Rule
      ERROR_MESSAGE = "Use a unique, consistent header style"

      def check!
        reference_style = nil

        # we need to dup otherwise seeking directly into the
        # @markdown.source confuses Inkmark and subsequent headers
        # will have nil byte ranges
        source = @markdown.source.lines.dup

        @markdown.on(:heading) do |header|
          line_number = line_number_from_byte_range(header.byte_range)

          style = source[line_number].start_with?("#") ? :normal : :underline

          reference_style ||= style

          error!(line_number) if reference_style != style
        end

        @markdown.walk
      end
    end
  end
end
