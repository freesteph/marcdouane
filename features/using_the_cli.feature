Feature: Using the command-line executable
  Scenario: The CLI provides a helpful banner
    When the command "bin/marcdouane" is ran
    Then the shell output contains "Commands:"

  Scenario: The CLI can tell its version
    When the command "bin/marcdouane version" is ran
    Then the shell output contains "0.1.0"
