# frozen_string_literal: true

require "dry/configurable"
require "uri"
require "inkmark"

URI_REGEXP = URI::RFC2396_PARSER.make_regexp

module Marcdouane
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

  # Ensure the first line, frontmatter or not, is a top-level header.
  class StartWithTopLevelHeader < Rule
    ERROR_MESSAGE = "The file should start with a top-level header."

    def check!
      sections = @markdown.chunks_by_heading

      if sections.empty? || sections.first[:level] != 1
        error!(1)
      end
    end
  end

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
            index + 1,
            ERROR_MESSAGE % self.class.maximum_line_length
          )
        end
      end
    end
  end

  # Ensure there are no consecutive blank lines
  class NoConsecutiveBlankLines < Rule
    ERROR_MESSAGE = "Consecutive blank lines"

    def check!
      @markdown
        .source
        .lines
        .each_cons(2)
        .each_with_index do |pair, index|
        if pair.map(&:strip).all?(&:empty?)
          error!(index + 3)
        end
      end
    end
  end
end
