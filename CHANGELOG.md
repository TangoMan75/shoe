Change Log
==========

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
- Add positional parameters to commands: all three kernels forward non-option arguments to the resolved command and validate them against the `@param` constraints.
- Add the `@terminal` Shoedoc tag for functions that exit the process on failure, and document it in `VOCABULARY.md`.
- Fix `entrypoint.sh build` to pass `--file` to `shoemaker` instead of the unsupported `-f`.
- Harden `_set_host` and `_remove_host` against hostname injection, and update the hosts file atomically.
- Prevent `_move` from deleting the source when the copy fails or the destination is inside the source.
- Make `_update` fail closed on download errors and preserve the installed script mode.
- Use an awk full match in `_is_valid`, so `-`-leading constraints are not parsed as `grep` options.
- Remove the duplicated Shoedoc schema, validator and ordering from `converter.py`; the converter now imports them from `shoemaker.py` and emits one `@depends` entry per line.
- Fix function body extraction for multi-line quoted awk programs.
- Replace non-POSIX `find -delete`, `grep -o`, `cp --archive`, untemplated `mktemp` and `sort -t` usages; document the remaining compatibility exceptions.
- Run the Python test suites in CI.
- Allow POSIX `case` blocks and private variables in framework modules, and relax the corresponding `AGENTS.md` rules.
- `shoemaker lint` accepts a single `.sh` file to check only that script, and several paths at once; directories are scanned recursively without skipping any folder, and a file may define several functions.
- `shoemaker lint` checks the `@assumes` tag of a script-level block against top-level code only, so function assumptions are no longer reported twice.
- `shoemaker build` ends generated scripts with the canonical single trailing blank line, so built scripts pass the linter.
- `shoemaker lint` reports `@depends` tags that carry several entries on one line, and `--fix` splits them into one tag per entry.
- `help <command>` now displays implicit first-letter short aliases for options and flags, unless the annotation declares its own alias.
- Remove implicit first-letter shorthand for commands: commands now require their full name. Options and flags keep their automatic first-letter short aliases, and explicit aliases still take precedence.
- Add command-level `@option` and `@flag` support: the kernel initialises defaults, validates annotation constraints, and rejects parameters that belong to another command.
- `help <command>` now prints the script usage, command examples, assumed variables, standard streams, flags and options instead of the function synopsis and block metadata.

