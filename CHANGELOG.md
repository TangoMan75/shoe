Change Log
==========

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
- The linter now validates `@assumes`: variables read from an outer scope must be listed, and entries the block never reads are rejected; `--fix` adds missing entries and drops unused ones.
- Add command-level `@option` and `@flag` support: the kernel initialises defaults, validates annotation constraints, and rejects parameters that belong to another command.
- Add a complete bookmarks example under `recipes/bookmarks` demonstrating global and command-level options, hooks, prompts and generated command help.
- `help <command>` now prints the script usage, command examples, assumed variables, standard streams, flags and options instead of the function synopsis and block metadata.
- Add a `migrate` command to `shoemaker.py` that removes the legacy `# Synopsis:` comment blocks duplicated inside shell functions.
- Shoedoc annotations now use classic `@`-prefixed tags only; the JSON envelope format is no longer supported.
- The `lint`, `build`, `dump` and `generate_doc` commands read and write classic `@`-tag annotations.
- Drop the `convert` command and the `--json` option from `dump` and `build`; drop the `_parse_shoedoc` and `remove_json_annotations` shell helpers.
- The `dump` command now organises functions into folders named after the `namespace` declared by their Shoedoc annotation and writes the matching `.shoe` build recipe; the `list` command is merged into it.
- The `dump` command's `.shoe` recipe now keeps every source line that was not exported into a function module, in source order.

