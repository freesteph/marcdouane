Feature: Using the command-line executable
  Scenario: The CLI provides a helpful banner
    When I run `marcdouane`
    Then the output should contain "Commands:"

  Scenario: The CLI can tell its version
    When I run `marcdouane version`
    Then the output should contain "0.1.0"
