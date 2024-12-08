TangoMan Shoe Light
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0-light
- link:    https://github.com/TangoMan75/shoe

## 📑 Description

Simplify your shell scripting workflow with self-documenting shell scripts with robust argument validation. Just prefix a comment with two pound signs (##) on the line above any function or variable to generate helpful documentation using the "help" command.  Light version is optimized for performance, does not handle flags, options, validation or docbloc parsing.  Features:   - [X] colors   - [X] commands   - [X] private functions   - [X] help   - [X] docbloc   - [ ] options + validation   - [ ] flags   - [ ] install + autocomplete + update   - [ ] compatibility   - [ ] documentation   - [ ] makefile  Warning: Functions names should not contain dashes.   

## 🔥 Usage

`sh shoe-light.sh [command] `

## 🧱 Constants

1. **WHO**
  - Constants will not convert to option at runtime. (must be uppercase)
  - Value: _World_

## 🤖 Commands

1. **`hello`**
  - Prints "Hello, World !" (the recipient's name is provided with the "WHO" constant)

2. **`help`**
  - Print help for current shoe script (default)

