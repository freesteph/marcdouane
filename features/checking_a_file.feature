Feature: Running checks against a file
  Scenario: The check command complains without a file
    When the command "bin/marcdouane check" is ran
    Then the shell output contains "No files provided"
