# frozen_string_literal: true

require "debug"
require "yaml"

require_relative "rules"

module Marcdouane
  class FileChecker
    class << self
      def call(file, options)
        verbose = options.fetch(:verbose)

        parse_config!(options[:config])

        puts "Checking `#{file}'..." if verbose

        exit_code = 0

        rules.each do |rule|
          rule.new(file, options).check!
        rescue Marcdouane::Error => e
          $stderr.puts("#{file}:#{e.line_number}: #{e.message}")

          exit_code = 1
        end

        puts "Done." if verbose

        exit_code
      end

      def parse_config!(path)
        return if path.nil?

        config = YAML.load_file(path)

        config.each do |klass, hash|
          hash.each do |key, value|
            rule_class = "Marcdouane::Rules::#{klass}"

            const_get(rule_class).class_eval do
              self.config[key.to_sym] = value
            end
          end
        end
      end

      def rules
        Marcdouane::Rules::Rule.subclasses
      end
    end
  end
end
