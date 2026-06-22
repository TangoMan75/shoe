## TangoMan Shoemaker
##
## Lint, migrate, convert, and build Shoedoc shell tools.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 0.1.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe
## {
##   "name": "shoemaker",
##   "summary": "TangoMan Shoemaker",
##   "description": "Lint, migrate, convert, and build Shoedoc shell tools.",
##   "authors": [
##     {
##       "name": "Matthias Morin",
##       "email": "mat@tangoman.io",
##       "homepage": "https://tangoman.io"
##     }
##   ],
##   "version": "0.1.0",
##   "license": "MIT",
##   "links": ["https://github.com/TangoMan75/shoe"],
##   "shell": "bash"
## }

# TangoMan Shoemaker
#
# `shoemaker.py` is the Python successor of the former `shoemaker.sh` tool.
# It validates Shoedoc annotations against the
# [vocabulary](../VOCABULARY.md), repairs common defects, migrates legacy
# blocks, converts between the classic `@`-tag form and the JSON envelope
# form, and extracts, builds and documents shell scripts.
#
# Usage: python3 shoemaker.py [command] (FILE) (--verbose) (--quiet) (--log)

# 🔥 Usage
#
#     python3 shoemaker.py [command]
#
# Global options, available on every command:
#
#     -v (--verbose)  Increase verbosity (stackable)
#     --quiet         Suppress non-primary output
#     --log           Log command output to the "log" folder
#     --completion    Print the bash completion script

# 🤖 Commands

#### ⌨️ 1. `lint`
#
# Lint the Shoedoc blocks of every `.sh` file under a folder, and report
# errors and warnings against the vocabulary. The script header block is
# validated as a script-level block (it cannot own a `namespace` or
# `requires` property); functions are validated and their `depends` /
# `requires` entries are cross-checked against the code.
#
# > Synopsis:
# > `lint FOLDER [--fix]`
#
#     python3 shoemaker.py lint src
#     python3 shoemaker.py lint src --fix
#
# `--fix` repairs supported issues in place: it generates missing JSON
# blocks from bare summaries, orders properties canonically, removes
# dangling commas, deduplicates `requires` / `depends` arrays and adds
# the entries statically detected in the function bodies.

#### ⌨️ 2. `migrate`
#
# Migrate legacy Shoedoc blocks to the current vocabulary: the legacy
# `parameters` array is split into `params`, `options` and `flags`, the
# removed `arguments`, `return` and `returns` properties are dropped, the
# legacy singular `link` property becomes a `links` array, and `required`
# is dropped from migrated options.
#
# > Synopsis:
# > `migrate PATH... [--dry-run]`
#
#     python3 shoemaker.py migrate --dry-run src
#     python3 shoemaker.py migrate src

#### ⌨️ 3. `convert`
#
# Convert the annotation blocks of shell scripts between the classic
# `@`-tag form and the JSON envelope form.
#
# > Synopsis:
# > `convert PATH... [--json] [--dry-run]`
#
#     python3 shoemaker.py convert --json src/shell
#     python3 shoemaker.py convert --dry-run recipes/shoe/hello.sh

#### ⌨️ 4. `dump`
#
# Extract every function of a shell script into individual files, each
# carrying its own Shoedoc annotation.
#
# > Synopsis:
# > `dump FILE [--destination DIR]`
#
#     python3 shoemaker.py dump --file shoe.sh --destination dump

#### ⌨️ 5. `list`
#
# Write the build list of a shell script: one component file per line, in
# the `-dump` folder, ready to feed the build command.
#
# > Synopsis:
# > `list FILE [--destination DIR]`
#
#     python3 shoemaker.py list --file shoe.sh

#### ⌨️ 6. `build`
#
# Build a shell script from a `.shoe` recipe file: recipe lines are
# either comments (kept as-is), blank lines, or component paths resolved
# relatively to the recipe file.
#
# > Synopsis:
# > `build FILE [--destination DIR] [--type {shell|sh|bash}]`
#
#     python3 shoemaker.py build --file recipes/shoe/shoe.shoe

#### ⌨️ 7. `generate_doc`
#
# Generate the Markdown documentation of a shell script from its Shoedoc
# annotations: script infos, description, usage, constants, options,
# flags and commands.
#
# > Synopsis:
# > `generate_doc FILE [--destination DIR] [--private]`
#
#     python3 shoemaker.py generate_doc --file shoe.sh --destination doc

#### ⌨️ 8. `generate_makefile`
#
# Generate a Makefile dispatching to the public functions documented in
# the script's Shoedoc annotations.
#
# > Synopsis:
# > `generate_makefile FILE [--destination DIR]`
#
#     python3 shoemaker.py generate_makefile --file shoe.sh

#### ⌨️ 9. `completion`
#
# Print the bash completion script for `shoemaker.py`.
#
# > Synopsis:
# > `completion`
#
#     python3 shoemaker.py completion > /etc/bash_completion.d/shoemaker
