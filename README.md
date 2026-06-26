# Marc d'Ouane

a beautiful, epic Markdown linter

![Logo](logo.jpeg)

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add marcdouane
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install marcdouane
```

## Usage

Checking a file with default rules:

```sh
marcdouane check some-file.md
```

For the complete tour just use

```sh
marcdouane
marcdouane check --help
```

## Development

I'm doing it

## Contributing

A rule must inherit `Marcdouane::Rule`. It must answer to `check!` and
raise a `Marcdouane::Error` with an `ERROR_MESSAGE` and a line
number. Example:

```ruby
class CheckAnglois < Marcdouane::Rule
  ERROR_MESSAGE = "Do not mention the English"

  def check!
    File
      .read(file)
      .lines
      .each_with_index(line, index) do
      raise Marcdouane:Error.new(ERROR_MESSAGE, index + 1) if line =~ /anglois/
    end
  end
end
```

It is then expected to be tested throughout the Cucumber feature tests
like such:

```feature
Feature: Built-in Markdown Rules
  # [...]

  Rule: Don't mention the English
    Example: It fails when the English are mentioned
      Given a file named "foo.md" with:
        """
        # Tout va bien
        Pas d'anglois à l'horizon
        """
      When I run `marcdouane check "foo.md"`
      Then it should fail with:
        """
        foo.md:2: Don't mention the English
        """

    Example: It passes when the English are not mentioned
      Given a file named "foo.md" with:
        """
        # Tout va bien
        Quelques voix dans la tête mais tranquille
        """
      When I run `marcdouane check "foo.md"`
      Then it should pass

```

Bug reports and pull requests are welcome on GitHub at
https://github.com/freesteph/marcdouane.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
