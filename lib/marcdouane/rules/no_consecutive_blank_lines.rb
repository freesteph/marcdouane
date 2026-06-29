# frozen_string_literal: true

module Marcdouane
  module Rules
    # Ensure there are no consecutive blank lines
    class NoConsecutiveBlankLines < Rule
      ERROR_MESSAGE = "Consecutive blank lines"

      def check!
        @markdown
          .source
          .lines
          .each_cons(2)
          .with_index do |pair, index|
          if pair.map(&:strip).all?(&:empty?)
            error!(index + 2)
          end
        end
      end
    end
  end
end
