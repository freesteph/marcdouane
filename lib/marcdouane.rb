# frozen_string_literal: true

require_relative "marcdouane/version"
require_relative "marcdouane/file_checker"

module Marcdouane
  class Error < StandardError
    attr_reader :msg, :line_number

    def initialize(msg, line_number)
      @msg = msg
      @line_number = line_number

      super(@msg)
    end
  end
end
