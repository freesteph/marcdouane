# frozen_string_literal: true

require "open3"

When("the command {string} is ran") do |cmd|
  @shell_output = Open3.capture2e(cmd).first
end

Then("the shell output contains {string}") do |str|
  expect(@shell_output).to include str
end
