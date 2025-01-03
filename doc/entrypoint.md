TangoMan Entrypoint
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0
- link:    https://github.com/TangoMan75/shoe


## 📑 Description

Execute Development and Continuous Integration tasks.  

## 🔥 Usage

`sh entrypoint.sh [command] (--lint_folder './build') (--test_folder './tests')`

## ⚙️ Options

1. **`--lint_folder`**
> Lint directory 
  - Constraint: `/~?[a-zA-Z0-9/._-]+/`
  - Default: _'./build'_

2. **`--test_folder`**
> Test directory 
  - Constraint: `/~?[a-zA-Z0-9/._-]+/`
  - Default: _'./tests'_

## 🤖 Commands

#### 1. `lint`

Sniff errors with linter

#### 2. `tests`

Run tests

#### 3. `git_hooks`

Install git hooks

#### 4. `bash_unit`

Install bash_unit framework

#### 5. `alpine`

Run script in Alpine Docker container

#### 6. `busybox`

Run script in Busybox Docker container

#### 7. `ubuntu`

Run script in Ubuntu Docker container

#### 8. `help`

Print this help

