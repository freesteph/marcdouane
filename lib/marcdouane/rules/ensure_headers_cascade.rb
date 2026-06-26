# frozen_string_literal: true

module Marcdouane
  module Rules
    # Ensure that every child header is always a direct descendant of
    # the previous header (i.e its level increments by 1).
    class EnsureHeadersCascade < Rule
      ERROR_MESSAGE = "Header levels should increment one at a time"

      def check!
        previous_level = nil

        @markdown.on(:heading) do |header|
          previous_level ||= header.level

          if header.level > previous_level && header.level != previous_level + 1
            error!(line_number_from_byte_range(header.byte_range))
          else
            previous_level = header.level
          end
        end

        @markdown.walk
      end
    end
  end
end
