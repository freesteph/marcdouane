# frozen_string_literal: true

require "debug"
require_relative "rules"

module Marcdouane
  class FileChecker
    class << self
      def call(file, options)
        verbose = options.fetch(:verbose)

        puts "Checking `#{file}'..." if verbose

        exit_code = 0

        # FIXME: this is wrong on about every possible layer of the
        # universe but It Works®
        if options[:config]
          eval(File.read(options[:config]))
        end

        rules.each do |rule|
          rule.new(file, options).check!
        rescue Marcdouane::Error => e
          $stderr.puts("#{file}:#{e.line_number}: #{e.message}")

          exit_code = 1
        end

        puts "Done." if verbose

        exit_code
      end

      def rules
        Marcdouane::Rule.subclasses
      end
    end
  end
end
