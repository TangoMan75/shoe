---
description: Convert a Bash script to POSIX sh with the convert-bash-to-posix-shell skill.
agent: build
---

# Convert Bash to POSIX Shell

This command is a thin input-gathering and argument-parsing layer. The full
procedural logic lives in the `convert-bash-to-posix-shell` skill, which is
reusable on its own.

## 1. Parse `$ARGUMENTS`

Resolve the target file or directory from `$ARGUMENTS`.

- If `$ARGUMENTS` contains one or more paths, capture them and do **not** ask
  for the target again.
- If `$ARGUMENTS` is empty or ambiguous, ask for the target path.
- If the target is under `src/shell/`, record that it is a framework POSIX
  module and that the strict rules apply. Otherwise record it as an ordinary
  script.

Pass the resolved paths and classification forward as context.

## 2. Delegate to the skill

Load and follow the canonical instructions in the `convert-bash-to-posix-shell`
skill (`.opencode/skills/convert-bash-to-posix-shell/SKILL.md`). All steps,
rules, and the output format are defined there.

Execute the skill using the input gathered above.
