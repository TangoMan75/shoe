TangoMan Shoe Maker
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0
- link:    https://github.com/TangoMan75/shoe

## 📑 Description

A developement tool to split a script file into its components or build a script from "build.lst" file.   

## 🔥 Usage

`sh shoemaker.sh [command] (--file '') (--destination '') (--type shell) `

## ⚙️ Options

1. **--file**
  - Description: Source file 
  - Constraint: `/~?[a-zA-Z0-9./_-]+/`
  - Default: ''

2. **--destination**
  - Description: Destination directory 
  - Constraint: `/~?[a-zA-Z0-9/._-]+/`
  - Default: ''

3. **--type**
  - Description: Script type 
  - Constraint: `/(shell|bash)/`
  - Default: shell

## 🤖 Commands

1. **dump**
  - Dump functions

2. **list**
  - Dump "build.lst" file

3. **build**
  - Build from given "build.lst" file

4. **build_all**
  - Build all scripts

5. **generate_doc**
  - Generate Markdown documentation for provided shoe script

### ⚡ Self Install

1. **self_install**
  - Install script and enable completion

2. **self_uninstall**
  - Uninstall script from system

### ⚡ Help

1. **help**
  - Print this help (default)

