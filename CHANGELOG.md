Change Log
==========

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
- Add a `migrate` command to `shoemaker.py` that removes the legacy `# Synopsis:` comment blocks duplicated inside shell functions.
- The `dump` command now organises functions into folders named after the `namespace` declared by their Shoedoc annotation and writes the matching `.shoe` build recipe; the `list` command is merged into it.
- The `dump` command accepts `--json` to convert the extracted functions' Shoedoc annotations to JSON envelopes.
- The `dump` command's `.shoe` recipe now keeps every source line that was not exported into a function module, in source order.

