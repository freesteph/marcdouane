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
        foo.md:0: The file should start with a top-level header
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
