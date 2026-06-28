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

        rules.each do |klass|
          rule = klass.new(file, options)

          rule.subscribe("rule.error") do |event|
            exit_code = 1

            print_error(
              file,
              rule,
              event[:line_number],
              event[:msg]
            )
          end

          rule.check!
        end

        puts "Done." if verbose

        exit_code
      end

      def print_error(file, rule, line_number, msg)
        $stderr.puts(
          format(
            "%{file}:%{line_number}: [%{rule_class}] %{message}",
            file:,
            line_number:,
            rule_class: rule.identifier,
            message: msg
          )
        )
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
