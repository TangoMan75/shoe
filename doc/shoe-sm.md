TangoMan Shoe SM
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0-sm
- link:    https://github.com/TangoMan75/shoe

## 📑 Description

Simplify your shell scripting workflow with self-documenting shell scripts with robust argument validation. Just prefix a comment with two pound signs (##) on the line above any function or variable to generate helpful documentation using the "help" command.  Features:   - [X] colors   - [X] commands   - [X] private functions   - [X] help   - [X] docbloc   - [X] options + validation   - [ ] flags   - [ ] install + autocomplete   - [ ] compatibility   - [ ] documentation  Warning: Functions names should not contain dashes.   

## 🔥 Usage

`sh shoe-sm.sh [command] (--who "World") `

## ⚙️ Options

1. **`--who`**
  - Description: Who do you want to say "hello" to ? 
  - Constraint: `/^[a-zA-Z-]+$/`
  - Default: _"World"_

## 🤖 Commands

1. **`hello`**
  - Say hello to arbitrary recipient

2. **`help`**
  - Print this help (default)

