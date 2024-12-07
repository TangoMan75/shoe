TangoMan Remove Dumplicate String
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0-sm
- link:    https://github.com/TangoMan75/shoe

## 📑 Description

Remove every line in target file that contains substrings from source file   

## 🔥 Usage

`sh remove_duplicate_strings.sh [command] (--source '') (--target '') `

## ⚙️ Options

1. **`--source`**
  - Description: Source file 
  - Constraint: `/~?[a-zA-Z0-9/._-]+/`
  - Default: _''_

2. **`--target`**
  - Description: Target file 
  - Constraint: `/~?[a-zA-Z0-9/._-]+/`
  - Default: _''_

## 🤖 Commands

1. **`dedupe_lines`**
  - Remove every line in target file that contains substrings from source file

2. **`help`**
  - Print this help (default)

