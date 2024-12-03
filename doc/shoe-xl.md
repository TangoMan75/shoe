
===

## ℹ️ Infos

- author:  
- version: 
- link:    

## 📑 Description



## 🔥 Usage

`sh shoe-xl.sh [command] (--who "World") (--count 1) (--env "dev") (--flag) (--global)`

## 🧱 Constants

1. **ALIAS**
  - Script alias
  - Value: shoe

## 🚩 Flags

1. **--flag**
  - Enable FooBar mode

2. **--global**
  - Install script globally

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

### ⚡ Self Install

1. **self_install**
  - Install script and enable completion

2. **self_uninstall**
  - Uninstall script from system

3. **self_update**
  - Update script from @update-link

### ⚡ Documentation

1. **generate_doc**
  - Generate Markdown documentation

### ⚡ Help

1. **help**
  - Print this help (default)

