![GH language](https://img.shields.io/github/languages/top/TangoMan75/shoe)
[![GH release](https://img.shields.io/github/v/release/TangoMan75/shoe)](https://github.com/TangoMan75/shoe/releases)
![GH license](https://img.shields.io/github/license/TangoMan75/shoe)
![GH stars](https://img.shields.io/github/stars/TangoMan75/shoe)
![Bash CI](https://github.com/TangoMan75/shoe/workflows/bash_unit%20CI/badge.svg)
![Shellcheck CI](https://github.com/TangoMan75/shoe/workflows/Shellcheck%20CI/badge.svg)
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2FTangoMan75%2Fshoe&labelColor=%23697689&countColor=%2337d67a&style=flat)

👠 TangoMan Shoe Shell Microframework
=====================================

A Lightweight script boilerplate for Posix Systems
--------------------------------------------------

Simplify your shell scripting workflow with self-documenting shell scripts with robust argument validation.
Just prefix a comment with two pound signs (##) on the line above any function or variable to generate helpful documentation using the "help" command.

![shoe](./doc/images/shoe.gif)

🤔 Why not simply use Make ?
----------------------------

While _GNU Make_ is a powerful build tool, it's not primarily designed for general-purpose scripting.
_GNU Make_ specialized syntax for defining dependencies and build rules can be less intuitive and less flexible than plain _Shell scripting_.
Also it's not always readily available on all _Linux_ distributions, especially in android based systems or minimal ones from _Docker_ containers like _Alpine_ or _Busybox_.

**TangoMan Shoe Shell Microframework** fills this gap by providing a lightweight, Posix-compatible alternative that's easy to set up and use.

🎯 Features
-----------

**TangoMan Shoe Shell Microframework** provides the following features:

1. **⚡ Shell Script Boilerplate:**

Use **TangoMan Shoe Shell Microframework** as a starting point for your own _shell scripts_, benefiting from its modular structure and best practices.

2. **⚡ Self-Documenting Shell Scripts:**

Prefix a comment with two pound signs (`##`) on the line above any _function_ or _variable_, the `help` command will generate documentation on the fly.

3. **⚡ Automatic Function-to-Command Conversion:**

Define your _functions_ as usual, they are automatically available as _commands_ at runtime, making your scripting more intuitive.

4. **⚡ Automatic Variable-to-Option Conversion:**

Define your global _variables_ as usual, they are converted as _options_ at runtime.

5. **⚡ Runtime Parameter Validation:**

Append a regular expression (eg: `/^a-zA-Z$/`) at the end of any _option_'s annotation, it will provide automatic validation at runtime.

6. **⚡ Automatic Boolean-to-Flag Conversion:**

Set a global variable to `false`, it creates a _flag_ for simple on/off settings.

7. **⚡ Automatic Shorthand:**

Shorthand for commands, options and flags are automatically created.

8. **⚡ POSIX Shell Compatibility:**

**TangoMan Shoe Shell Microframework** is 100% POSIX compliant, run your scripts in virtually any environment, including containers and android based systems.

9. **⚡ MacOS Compatibility Layer:**

**TangoMan Shoe Shell Microframework** provides optional compatibility functions, since some _shell_ commands syntax can vary between _Mac_ and _Linux_ (eg: `sed`).

10. **⚡ Global Installation With Autocomplete:**

Install and use your custom command across your system, **TangoMan Shoe Shell Microframework** will dump and load the appropriate _comspec_ in your `sh`, `bash` or `zsh` terminal.

11. **⚡ Generate Markdown Documentation From Scripts:**

Automate the generation of Markdown documentation for Shoe scripts. It extracts information from the script annotations to generate documentation.

12. **⚡ Generate Makefile From Scripts:**

Automate the creation of Makefiles for Shoe scripts. It extracts information from the provided script to generate help messages and build rules.

13. **⚡ Shellcheck Validation:**

**TangoMan Shoe Shell Microframework** codebase is 100% shellcheck validated, it will not trigger any warnings or errors in your CI/CD pipeline.

14. **⚡ Unit Test Coverage:**

**TangoMan Shoe Shell Microframework** codebase is thoroughly covered with _bashunit_ tests, ensuring code quality and reliability.

15. **⚡ Markdown Documentation Generator:**

Generate a comprehensive _README.md_ documentation from your own source code.

16. **⚡ Command Grouping:**

Prefix a comment with three pound signs (`###`) to organize related commands into categories for better help output.

17. **⚡ Shoemaker Developement Tool:**

Use `shoemaker.sh` tool to split a source script file into its components or build a script from a _"build.lst"_ template file.

📑 Documentation
----------------

### 📝 Full shoe documentation can be found here:

- [./doc/shoe.md](./doc/shoe.md)

### 📝 Documentation for `shoemaker.sh` can be found here:

- [./doc/shoemaker.md](./doc/shoemaker.md)

### 📝 Example documentation for light version can be found here:

- [./doc/shoe-light.md](./doc/shoe-light.md)

### 📝 Documentation for `entrypoint.sh` can be found here:

- [./doc/entrypoint.md](./doc/entrypoint.md)

### 📝 Self Documentation

#### 📝 Annotations

Prefix a comment with two pound signs on the previous line of any function or variable you want documented with the "help" command.

"help" prints commands in the order they appear in the script.

#### 📝 Sections

Group your functions by categories by dividing them with a title prefixed with three pound signs.

#### 📝 Docbloc

Change displayed title and description by editing docblock infos at the top of the actual file.

```bash
#/**
# * Script Title
# *
# * Place here script description.
# *
# * @author  "Your Name" <your@email.com>
# * @version 0.1.0
# * @link    https://your.website.com
# */
```

### 🔥 Runnig scripts

Shorthands are available for the first function, flag or variable with a given alphabetial character.

eg:

```bash
$ sh shoe.sh h
# will return the same result as
$ sh shoe.sh hello
```
as long as no other function starts with the letter "h" in the script. In that case only the first one will be executed.

```bash
$ sh shoe.sh hello -f
# is the same as
$ sh shoe.sh hello --foobar
# and
$ sh shoe.sh hello -w TangoMan
# is the same as
$ sh shoe.sh hello --who TangoMan
```

#### 🔥 Constants

Uppercase variables appear in the "help" but cannot be set from the command line.

#### 🔥 Private elements

Private constants and functions are prefixed with underscore : They do not show up in the "help" and are not available from the command line.

```bash
#--------------------------------------------------
# Place your parameters after this line
#--------------------------------------------------

## Who do you want to say "hello" to ? /[a-zA-Z]+/
who="World"

## How many times to say hello /[1-9]/
count=1

## Enable FooBar mode
flag=false

## Environment /(prod|dev|test)/
env="dev"

## Constants are ignored (must be uppercase)
VERSION=0.3.0

## Private constants (and variables) are prefixed with underscore
_SECRET=this_not_so_secret

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

## Say hello to arbitrary recipient
hello() {
    loop=0
    while [ "${loop}" -lt "${count}" ]; do
        echo "Hello ${who} !"
        loop=$((loop+1))
    done

    if [ "${flag}" = true ]; then
        echo "FOOBAR MODE ENABLED !"
    fi
}

## This is a private function
_version() {
    echo "${env}"
    echo "${VERSION}"
    echo "${_SECRET}"
}
```

The example above will generate this result:

![example](./doc/images/example.png)

### 🔎 Validation

Unknown command will raise following error:
![error_command](./doc/images/error_command.png)

Unknown option will raise following error:
![error_option](./doc/images/error_option.png)

Illegal argument will raise following error:
![error_validation](./doc/images/error_validation.png)

### 🍭 Flavors

**TangoMan Shoe Shell Microframework** is available in standard and light version.

#### 🌈 Light Version

_shoe-sm.sh_ is designed for simplicity and optimized for performance, does not handle flags, options, validation or docbloc parsing.

### 🐛 Limitations

#### 🐛 Function names

⚠️ Function names should not not contain dashes.

#### 🐛 Repetition

⚠️ Function will execute as many times as parameter is given, for example the command below will execute the `hello` function thee times.

```bash
$ sh shoe.sh hello hello hello
```

#### 🐛 Flags

⚠️ Last flag or option will overwrite variable value.

```bash
$ sh shoe.sh hello --who=foo --who=bar
```
The command above will return :
```
Hello bar !
```

#### 🐛 Validation

⚠️ Validation regex cannot contain interval syntax.

The following syntax will not work properly :

```
## Local IP address /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/
ip=127.0.0.1
```

whereas this one will :

```
## Local IP address /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/
ip=127.0.0.1
```

💻 Dependencies
---------------

**TangoMan Shoe Shell Microframework** requires the following dependencies:

- Awk
- Sed
- Shell (ash supported)
- Docker (dev)
- bash_unit (dev)
- Shellcheck (dev)

🤝 Contributing
---------------

Thank you for your interrest in contributing to **TangoMan Shoe Shell Microframework**.

Please review the [code of conduct](./CODE_OF_CONDUCT.md) and [contribution guidelines](./CONTRIBUTING.md) before starting to work on any features.

If you want to open an issue, please check first if it was not [reported already](https://github.com/TangoMan75/shoe/issues) before creating a new one.

📜 License
----------

Copyrights (c) 2024 &quot;Matthias Morin&quot; &lt;mat@tangoman.io&gt;

[![License](https://img.shields.io/badge/Licence-MIT-green.svg)](LICENSE)
Distributed under the MIT license.

If you like **TangoMan Shoe Shell Microframework** please star, follow or tweet:

[![GitHub stars](https://img.shields.io/github/stars/TangoMan75/shoe?style=social)](https://github.com/TangoMan75/shoe/stargazers)
[![GitHub followers](https://img.shields.io/github/followers/TangoMan75?style=social)](https://github.com/TangoMan75)
[![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2FTangoMan75%2Fshoe)](https://twitter.com/intent/tweet?text=Wow:&url=https%3A%2F%2Fgithub.com%2FTangoMan75%2Fshoe)

... And check my other cool projects.

🙏 Acknowledgements
-------------------

- This script was inspired by **Peter Forret** [bashew](https://github.com/pforret/bashew)
- [bash_unit](https://github.com/pgrange/bash_unit): bash unit testing enterprise edition framework (used for CI/CD)
- [shellcheck](https://github.com/koalaman/shellcheck): a static analysis tool for shell scripts (used for CI/CD)
