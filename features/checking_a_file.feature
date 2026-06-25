Feature: Running checks against a file
  Scenario: The check command complains without a file
    Given I successfully run `marcdouane check`
    Then the output should contain "No files provided"

  Scenario: The check command can check one file
    Given an empty file named "test.md"
    When I successfully run `marcdouane check test.md`
    Then the output should contain "Checking `test.md'"

  Scenario: The check command can check multiple files
    Given an empty file named "foo.md"
    And an empty file named "bar.md"
    When I successfully run `marcdouane check foo.md bar.md`
    Then the output should contain "Checking `foo.md'"
    And the output should contain "Checking `bar.md'"

  Scenario: The check command fails with non-existant files
    Given an empty file named "foo.md"
    When I run `marcdouane check foo.md bar.md`
    Then it should fail with:
      """
      `bar.md' is missing, or not a valid file.
      """
