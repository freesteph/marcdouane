Feature: Using the command-line executable
  Scenario: The CLI provides a help flag
    When the command "bin/marcdouane --help" is run in a shell
    Then the shell contains "marcdouane is here to help"
