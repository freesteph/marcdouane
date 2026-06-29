# frozen_string_literal: true

require "debug"
require "yaml"

require_relative "rules"

module Marcdouane
  # FileChecker grabs all rules available and then calls them on a
  # file, transmitting any options fed to the CLI.  and then calls all
  # the rules
  class FileChecker
    class << self
      attr_reader :exit_code

      def call(file, options)
        verbose = options.fetch(:verbose)

        parse_config!(options[:config]) unless options[:config].nil?

        puts "Checking `#{file}'..." if verbose

        @exit_code = 0

        rules
          .map { |klass| run_rule(file, klass, options) }
          .tap  { |_codes| puts "Done." if verbose }
          .then { @exit_code }
      end

      def run_rule(file, klass, options)
        rule = klass.new(file, options)

        rule.subscribe("rule.error") do |event|
          print_error(file, rule, event[:line_number], event[:msg])

          @exit_code = 1
        end

        rule.check!
      end

      def print_error(file, rule, line_number, msg)
        warn(
          format(
            "%<file>s:%<line_number>s: [%<rule_class>s] %<message>s",
            file:,
            line_number:,
            rule_class: rule.identifier,
            message: msg
          )
        )
      end

      def parse_config!(path)
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
