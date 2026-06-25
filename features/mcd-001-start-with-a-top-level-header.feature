Feature: Starts with a top-level header
  Scenario: It fails when the file does not start with a top-level header
    Given a file named "foo.md" with:
      """
      ## This is a file starting with a level-2 header
      """
    When I run `marcdouane check "foo.md"`
    Then it should fail with:
      """
      foo.md:1: Files should start with a top-level header
      """
