# frozen_string_literal: true

require_relative "rules/rule"

Dir["#{File.dirname(__FILE__)}/rules/*.rb"].map(&method(:require))
