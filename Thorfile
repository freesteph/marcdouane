# frozen_string_literal: true

require "thor/group"

# Generates a new rule for Marcdouane, prompting an error message and
# filling in some tests too.
class GenerateRule < Thor::Group
  include Thor::Actions

  desc "Generate a new rule for Marcdouane"

  argument :name,
           type: :string,
           desc: "Camel-case identifier of the rule"

  def create_rule_file
    create_file "lib/marcdouane/rules/#{underscore(name)}.rb" do
      @msg = ask("What is the error message to be displayed on a faulty line?")

      <<~RB
        # frozen_string_literal: true

        module Marcdouane
          module Rules
            class #{name} < Rule
              ERROR_MESSAGE = "#{@msg}"

              def check!; end
            end
          end
        end
      RB
    end
  end

  def add_test_case
    append_to_file "features/rules.feature" do
      <<-CUKE

  @wip
  Rule: #{@msg}
    Example: FIXME
      Given a file named "foo.md" with:
      """
      Faulty content
      """
      When I run `marcdouane check "foo.md"`
      Then it should fail with:
      """
      foo.md:1: [#{name}] #{@msg}
      """
      CUKE
    end
  end

  def letsgo
    puts "Done! Use `bundle exec cucumber -t @wip` to get going."
  end

  private

  def underscore(str)
    str.instance_eval do
      gsub("::", "/")
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr("-", "_")
        .downcase
    end
  end
end
