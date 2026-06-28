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
        File.binread(file, range.first).count("\n")
      end

      def identifier
        self.class.to_s.split("::").last
      end

      # Produces an error that will be collected and output by the
      # CLI. It must be called with the 0-indexed line-number, and an
      # optional `message` override instead of the class's
      # ERROR_MESSAGE.
      def error!(machine_line_number, message = nil)
        msg = message || self.class.const_get("ERROR_MESSAGE")

        raise Marcdouane::Error.new(
          "[#{identifier}] #{msg}",
          machine_line_number + 1
        )
      end
    end
  end
end
