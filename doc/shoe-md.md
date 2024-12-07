TangoMan Shoe MD
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0-md
- link:    https://github.com/TangoMan75/shoe

## 📑 Description

Simplify your shell scripting workflow with self-documenting shell scripts with robust argument validation. Just prefix a comment with two pound signs (##) on the line above any function or variable to generate helpful documentation using the "help" command.  Features:   - [X] colors   - [X] commands   - [X] private functions   - [X] help   - [X] docbloc   - [X] options + validation   - [X] flags   - [ ] install + autocomplete   - [ ] compatibility   - [ ] documentation  Warning: Functions and variables names should not contain dashes.   

## 🔥 Usage

`sh shoe-md.sh [command] (--who "World") (--flag)`

## 🚩 Flags

1. **`--flag`**
  - Enable Flag

## ⚙️ Options

1. **`--who`**
  - Description: Who do you want to say "hello" to ? 
  - Constraint: `/^[a-zA-Z-]+$/`
  - Default: _"World"_

## 🤖 Commands

1. **`hello`**
  - Say hello to arbitrary recipient

2. **`flag_test`**
  - Prints flag status

3. **`self_install`**
  - Install script and enable completion

4. **`self_uninstall`**
  - Uninstall script from system

5. **`self_update`**
  - Update script from @update-link

6. **`generate_doc`**
  - Generate Markdown documentation for current shoe script

7. **`help`**
  - Print this help (default)

