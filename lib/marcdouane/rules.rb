# frozen_string_literal: true

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
    end
  end

  class StartWithTopLevelHeader < Rule
    ERROR_MESSAGE = "The file should start with a top-level header."

    def check!
      File
        .read(file)
        .lines
        .each_with_index do |line, index|
        if !line.match?("foobar")
          raise Marcdouane::Error.new(ERROR_MESSAGE, index)
        end
      end
    end
  end
end
