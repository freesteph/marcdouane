# frozen_string_literal: true

require "dry/configurable"
require "dry/events/publisher"
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
      include Dry::Events::Publisher[:marcdouane] # I don't know what that identifier is for

      attr_reader :file, :options, :markdown, :source

      def initialize(file, options)
        @file = file
        @options = options
        @markdown = Inkmark.new(
          File.read(file),
          options: {
            frontmatter: true
          }
        )

        @source = @markdown.source.dup

        register_event("rule.error")
      end

      def line_number_from_byte_range(range)
        File.binread(file, range.first).count("\n")
      end

      def identifier
        self.class.to_s.split("::").last
      end

      # Publishes an error event, picked up by the FileChecker
      # somewhere down the line. It must be called with the 0-indexed
      # line-number, and an optional `message` override instead of the
      # class's ERROR_MESSAGE.
      def error!(machine_line_number, message = nil)
        msg = message || self.class.const_get("ERROR_MESSAGE")

        publish("rule.error", msg: msg, line_number: machine_line_number + 1)
      end
    end
  end
end
