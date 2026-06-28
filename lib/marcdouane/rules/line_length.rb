# frozen_string_literal: true

require "uri"

URI_REGEXP = URI::RFC2396_PARSER.make_regexp

module Marcdouane
  module Rules
    # Ensure the line-length does not go over the default (80)
    # character limit. Link references are not accounted for.
    class LineLength < Rule
      ERROR_MESSAGE = "Line-length is over %s characters"

      setting :maximum_line_length, default: 80, reader: true

      def check!
        @markdown.source.lines.each_with_index do |line, index|
          if line.match?(/^\[.*\]: #{URI_REGEXP}$/)
            next
          elsif line.length > self.class.maximum_line_length
            error!(
              index,
              ERROR_MESSAGE % self.class.maximum_line_length
            )
          end
        end
      end
    end
  end
end
