# frozen_string_literal: true

require "debug"
require_relative "rules"

module Marcdouane
  class FileChecker
    class << self
      def call(file, options)
        verbose = options.fetch(:verbose)

        puts "Checking `#{file}'..." if verbose

        rules.each do |rule|
          rule.new(file, options).check!
        rescue Marcdouane::Error => e
          $stderr.puts("#{file}:#{e.line_number}: #{e.message}")

          raise e
        end

        puts "Done." if verbose
      end

      def rules
        Marcdouane::Rule.subclasses
      end
    end
  end
end
