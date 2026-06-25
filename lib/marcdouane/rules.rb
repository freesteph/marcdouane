# frozen_string_literal: true

require 'inkmark'

module Marcdouane
  class Rule
    attr_reader :file, :options

    def initialize(file, options)
      @file = file
      @options = options
    end

    def call
      check!
    rescue Marcdouane::Error => e
      $stderr.puts("#{file}:#{e.line_number}: #{e.message}")
      exit 1
    end
  end

  class StartWithTopLevelHeader < Rule
    ERROR_MESSAGE = "The file should start with a top-level header."

    def check!
      md = Inkmark.new(File.read(file))

      sections = md.chunks_by_heading

      if sections.empty? || sections.first[:level] != 1
        raise Marcdouane::Error.new(ERROR_MESSAGE, 0)
      end
    end
  end
end
