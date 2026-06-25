# frozen_string_literal: true

module Marcdouane
  class FileChecker
    class << self
      def call(file)
        puts "Checking `#{file}'..."

        puts "Done."
      end
    end
  end
end
