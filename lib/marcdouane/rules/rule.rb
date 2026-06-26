# frozen_string_literal: true

require "dry/configurable"
require "inkmark"

module Marcdouane
  module Rules
    # Rule is the base class to regroup all rules. It is initialized
    # with a file path and some options forwarded from the CLI
    # invocation.
    #
    # Subclasses must implement `check!` and provide an
    # ERROR_MESSAGE when the check fails.
    class Rule
      extend Dry::Configurable

      attr_reader :file, :options, :markdown

      def initialize(file, options)
        @file = file
        @options = options
        @markdown = Inkmark.new(
          File.read(file),
          options: {
            frontmatter: true
          }
        )
      end

      def line_number_from_byte_range(range)
        @markdown
          .source
          .lines
          .find_index { |l| l == @markdown.source[range] }
          .succ
      end

      def error!(line_number, message = nil)
        raise Marcdouane::Error.new(
          message || self.class.const_get("ERROR_MESSAGE"),
          line_number
        )
      end
    end
  end
end
