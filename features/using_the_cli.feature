Feature: Using the command-line executable
  Scenario: The CLI provides a helpful banner
    When I run `marcdouane`
    Then the output should contain "Commands:"

  Scenario: The CLI can tell its version
    When I run `marcdouane version`
    Then the output should contain "0.1.0"

  Scenario: All the errors are displayed
    Given a file named "foo.md" with:
      """
      ## This is a file starting with a level-2 header
      #### This goes directly to H4
      """
    When I run `marcdouane check "foo.md"`
    Then it should fail with:
      """
      foo.md:1: [StartWithTopLevelHeader] The file should start with a top-level header
      foo.md:2: [EnsureHeadersCascade] Header levels should increment one at a time
      """

  Scenario: Rules fire for every line
    Given a file named "foo.md" with:
      """
      ## This is a file starting with a level-2 header
      #### This goes directly to H4
      ###### This goes directly to H6
      """
    When I run `marcdouane check "foo.md"`
    Then it should fail with:
      """
      foo.md:1: [StartWithTopLevelHeader] The file should start with a top-level header
      foo.md:2: [EnsureHeadersCascade] Header levels should increment one at a time
      foo.md:3: [EnsureHeadersCascade] Header levels should increment one at a time
      """
