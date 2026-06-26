Feature: Built-in Markdown Rules
  Rule: The document starts with a top-level header
    Example: The document does not start with a top-level header
      Given a file named "foo.md" with:
        """
        ## This is a file starting with a level-2 header
        """
      When I run `marcdouane check "foo.md"`
      Then it should fail with:
        """
        foo.md:1: The file should start with a top-level header
        """

    Example: Frontmatter data is not accounted for
      Given a file named "foo.md" with:
        """
        ---
        foo: bar
        ---

        # This is a file starting with a top-level header
        """
      When I run `marcdouane check "foo.md"`
      Then it should pass

  Rule: The header levels should only increment by one
    Example: A document goes from H2 to H4
      Given a file named "foo.md" with:
        """
        # This is a file starting with a top-level header
        ## This is an H2
        #### But this is an H4
        """
      When I run `marcdouane check "foo.md"`
      Then it should fail with:
        """
        foo.md:3: Header levels should increment one at a time
        """

    Example: A document respect the header hiearchy
      Given a file named "foo.md" with:
        """
        # This is a file starting with a top-level header
        ## This is an H2
        ### This is an H3
        ## Another H2
        """
      When I run `marcdouane check "foo.md"`
      Then it should pass

  Rule: The line-length is capped at 80 characters
    Example: A document with a long line
      Given a file named "foo.md" with:
        """
        # Example file
        This line is really long and carries over the limit for a comfortable read and annoys everybody
        """
      When I run `marcdouane check "foo.md"`
      Then it should fail with:
        """
        foo.md:2: Line-length is over 80 characters
        """

    Example: A link anchor is not accounted for
      Given a file named "foo.md" with:
        """
        # Example file

        This is a reference[1] to a link.

        [1]: https://github.com/freesteph/marcdouane/commit/212d702ef34a236597e7b42c09247766276b87f5
        """
      When I run `marcdouane check "foo.md"`
      Then it should pass

    Example: The line length can be configured
      Given a file named "foo.md" with:
        """
        # Example file
        This line is really long and carries over the limit for a comfortable read and annoys everybody
        """
      And a file named ".marcdouane.yml" with:
        """
        LineLength:
          maximum_line_length: 400
        """
      When I run `marcdouane check --config .marcdouane.yml "foo.md"`
      Then it should pass

  Rule: No consecutive blank lines
    Example: When there are two consecutive blank lines
      Given a file named "foo.md" with:
        """
        Some text


        More text two lines away
        """
      When I run `marcdouane check "foo.md"`
      Then it should fail with:
        """
        foo.md:4: Consecutive blank lines
        """

  Scenario: All the errors are displayed
    Given a file named "foo.md" with:
      """
      ## This is a file starting with a level-2 header
      #### This goes directly to H4
      """
    When I run `marcdouane check "foo.md"`
    Then it should fail with:
      """
      foo.md:1: The file should start with a top-level header
      foo.md:2: Header levels should increment one at a time
      """
