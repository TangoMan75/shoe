TangoMan Shoe MD
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0-md
- link:    https://github.com/TangoMan75/shoe

## 📑 Description

Simplify your shell scripting workflow with self-documenting shell scripts with robust argument validation. Just prefix a comment with two pound signs (##) on the line above any  function or variable to generate helpful documentation using the "help" command.  Features:   - [X] colors   - [X] commands   - [X] private functions   - [X] help   - [X] docbloc   - [X] options + validation   - [X] flags   - [ ] install + autocomplete   - [ ] compatibility   - [ ] documentation  Warning: Functions and variables names should not contain dashes.   

## 🔥 Usage

`sh shoe-md.sh [command] (--who "World") (--count 1) (--env "dev") (--flag)`

## 🚩 Flags

1. **--flag**
  - Enable FooBar mode

## ⚙️ Options

1. **--who**
  - Description: Who do you want to say "hello" to ? 
  - Constraint: `/^[a-zA-Z-]+$/`
  - Default: "World"

2. **--count**
  - Description: How many times to say hello 
  - Constraint: `/^[1-9]$/`
  - Default: 1

3. **--env**
  - Description: Environment 
  - Constraint: `/^(prod|dev|test)$/`
  - Default: "dev"

## 🤖 Commands

1. **hello**
  - Say hello to arbitrary recipient

2. **version**
  - Return script version from "@version" parameter in file docbloc

3. **print_env**
  - Print environment

### ⚡ Help

1. **help**
  - Print this help (default)

