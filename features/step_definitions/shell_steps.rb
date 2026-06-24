# frozen_string_literal: true

When('the command {string} is run in a shell') do |cmd|
  @shell_output = `#{cmd}`
end

Then('the shell contains {string}') do |str|
  puts "shell output is #{@shell_output}"
  expect(@shell_output).to include str
end
