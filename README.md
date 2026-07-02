# Marc d'Ouane

a beautiful, epic Markdown linter

![Logo](logo.jpeg)

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add marcdouane
```

If bundler is not being used to manage dependencies, install the gem
by executing:

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

## Configuration

Some rules have settings (see `lib/marcdouane/rules.rb` for
now). These settings can be overriden with a YAML config file that
resembles the Rubocop config:

```yaml
LineLength:
  maximum_line_length: 90 # which is utter madness
```

## Editor integration

Marcdouane uses a very common output format:

```
filename:lineno: [ErrorName] error message
```

### Emacs with Flycheck

```elisp
(flycheck-define-checker marcdouane
  "A Markdown linter using marcdouane

See URL `https://github.com/freesteph/marcdouane/'."
  :command ("marcdouane" "check" source)
  :error-patterns
  ((error line-start (file-name) ":" line ": " (message) line-end))
  :error-explainer (lambda (err)
                     (let ((str (flycheck-error-message err)))
                       (when (string-match "\\[\\([^]]+\\)\\]" str)
                         (let* ((class (match-string 1 str)))
                           (shell-command-to-string (format "ri --format=markdown --no-pager Marcdouane::Rules::%s" class))))))
  :modes markdown-mode)

(add-to-list 'flycheck-checkers 'marcdouane)
```

## Development

I'm doing it

## Contributing

You can generate a new rule with `bundle exec thor generate_rule
YourRuleName` which will write the class file, require it and add a
new test-case for it.

A rule must inherit `Marcdouane::Rule`. It must answer to `check!`
and call `error!` to signal a faulty line. The message defaults to the
class's `ERROR_MESSAGE` but can be overriden through the `message`
parameter. The line-number is 0-indexed. Example:

```ruby
class CheckAnglois < Marcdouane::Rule
  ERROR_MESSAGE = "Do not mention the English"

  def check!
    File
      .read(file)
      .lines
      .each_with_index do |line, index|
      error!(index) if line =~ /anglois/
    end
  end
end
```

This will get the CLI to output:

```
<filename>:<line_number>: [CheckAnglois] Do not mention the English
```

All rules are expected to be tested via the extensive test suite in
`features/rules.features`, using Cucumber and Aruba like such:

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
