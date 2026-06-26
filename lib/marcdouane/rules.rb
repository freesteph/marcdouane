# frozen_string_literal: true

require "inkmark"

module Marcdouane
  # Rule is the base class to regroup all rules. It is initialized
  # with a file path and some options forwarded from the CLI
  # invocation.
  #
  # Subclasses must implement `check!` and provide an
  # ERROR_MESSAGE when the check fails.
  class Rule
    attr_reader :file, :options

    def initialize(file, options)
      @file = file
      @options = options
    end
  end

  # StartWithTopLevelHeader
  #
  # Ensure the first line, frontmatter or not, is a top-level header.
  class StartWithTopLevelHeader < Rule
    ERROR_MESSAGE = "The file should start with a top-level header."

    def check!
      md = Inkmark.new(File.read(file), options: { frontmatter: true })

      sections = md.chunks_by_heading

      if sections.empty? || sections.first[:level] != 1
        raise Marcdouane::Error.new(ERROR_MESSAGE, 0)
      end
    end
  end
end
