# frozen_string_literal: true

module Marcdouane
  module Rules
    # Ensure that there is only a single top-level header in the file.
    class SingleTopLevelHeader < Rule
      ERROR_MESSAGE = "A top-level header is already present"

      def check!
        previously_seen = false

        @markdown.on(:heading) do |header|
          if header.level == 1
            if previously_seen
              error!(line_number_from_byte_range(header.byte_range))
            else
              previously_seen = true
            end
          end
        end

        @markdown.walk
      end
    end
  end
end
