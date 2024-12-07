TangoMan Shoe XL
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io> "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0-xl 1.0.0
- link:    https://github.com/TangoMan75/shoe https://github.com/TangoMan75/shoe

## 📑 Description

Simplify your shell scripting workflow with self-documenting shell scripts with robust argument validation. Just prefix a comment with two pound signs (##) on the line above any function or variable to generate helpful documentation using the "help" command.  Features:   - [X] colors   - [X] commands   - [X] private functions   - [X] help   - [X] docbloc   - [X] options + validation   - [X] flags   - [X] install + autocomplete   - [X] compatibility   - [X] documentation  Warning: Functions and variables names should not contain dashes.    TangoMan shoe  Run "make" to print help If you want to add a help message for your rule,  just add : "## My help for this rule", on the previous line use : "### " to group rules by categories You can give "make" arguments with this syntax: PARAMETER=VALUE   

## 🔥 Usage

`sh shoe-xl.sh [command] (--who "World") (--flag) (--global)`

## 🧱 Constants

1. **ALIAS**
  - Script alias
  - Value: _shoe_

## 🚩 Flags

1. **`--flag`**
  - Enable Flag

2. **`--global`**
  - Install script globally

## ⚙️ Options

1. **`--who`**
  - Description: Who do you want to say "hello" to ? 
  - Constraint: `/^[a-zA-Z-]+$/`
  - Default: _"World"_

## 🤖 Commands

1. **`hello`**
  - Say hello to arbitrary recipient

2. **`flag_test`**
  - Prints flag status

3. **`_private`**
  - Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.

### ⚡ Hooks

1. **`_default`**
  - Place here commands you need executed by default

2. **`_before`**
  - Place here commands you need executed first every time

3. **`_after`**
  - Place here commands you need executed last every time

### ⚡ Colors

1. **`echo_primary`**
  - Print primary (bright white text)

2. **`echo_secondary`**
  - Print secondary (bright blue text)

3. **`echo_success`**
  - Print success (bright green text)

4. **`echo_danger`**
  - Print danger (red text)

5. **`echo_warning`**
  - Print warning (orange text)

6. **`echo_info`**
  - Print info (bright purple text)

7. **`echo_light`**
  - Print light (black text over white background)

8. **`echo_dark`**
  - Print dark (white text over black background)

9. **`alert_primary`**
  - Print primary alert (bold white text over bright blue background)

10. **`alert_secondary`**
  - Print secondary alert (bold white text over bright purple background)

11. **`alert_success`**
  - Print success alert (bold white text over bright green background)

12. **`alert_danger`**
  - Print danger alert (bold white text over bright red background)

13. **`alert_warning`**
  - Print warning alert (bold white text over bright orange background)

14. **`alert_info`**
  - Print info alert (bold white text over bright blue background)

15. **`alert_light`**
  - Print light alert (black text over white background)

16. **`alert_dark`**
  - Print dark alert (bold white text over black background)

### ⚡ Self Install

1. **`self_install`**
  - Install script and enable completion

2. **`self_uninstall`**
  - Uninstall script from system

3. **`self_update`**
  - Update script from @update-link

4. **`_symlink_install`**
  - Install script via symlink

5. **`_copy_install`**
  - Install script via copy (beta)

6. **`_generate_autocomplete`**
  - Generates an autocomplete script for the provided file.

7. **`_generate_global_autocomplete`**
  - Creates a system-wide autocomplete script for the provided file.

8. **`_get_comspec`**
  - Generate comspec string

9. **`_remove_completion_autoload`**
  - Remove completion script autoload

10. **`_set_completion_autoload`**
  - Adds an autoload line for completion script to a shell configuration file.

11. **`__set_completion_autoload`**

12. **`_uninstall`**
  - Uninstall script from system

13. **`_update`**
  - Updates the script from the provided URL.

### ⚡ Documentation

1. **`generate_doc`**
  - Generate Markdown documentation for current shoe script

2. **`_generate_doc`**
  - Generate Markdown documentation for provided shoe script

### ⚡ Makefile

1. **`generate_makefile`**
  - Generate Makefile documentation for current shoe script

2. **`_generate_makefile`**
  - Generate Makefile documentation for provided shoe script

### ⚡ Help

1. **`help`**
  - Print this help (default)

2. **`_get_padding`**
  - Guess padding length from longest command of the current shoe script

3. **`_print_title`**
  - Print provided text formatted as a description

4. **`_print_infos`**
  - Print infos of the of the current shoe script

5. **`_print_description`**
  - Print provided text formatted as a description

6. **`_print_usage`**
  - Print usage of the of the current shoe script

7. **`_print_flags`**
  - List flags of the of the current shoe script

8. **`_print_constants`**
  - List constants of the of the current shoe script

9. **`_print_options`**
  - List options of the of the current shoe script

10. **`_print_commands`**
  - List commands of the of the current shoe script

### ⚡ Docbloc

1. **`_get_docbloc`**
  - Get docbloc at the top the provided shoe script file

2. **`_get_docbloc_description`**
  - Get docbloc description at the top the provided shoe script file

3. **`_get_docbloc_title`**
  - Get docbloc title at the top the provided shoe script file

### ⚡ System compatibility

1. **`_open`**
  - Open with default handler

2. **`_sed_i`**
  - Return sed -i system flavour

### ⚡ Git

1. **`git_hooks`**
  - Install git hooks

### ⚡ Network

1. **`_set_host`**
  - Set new host in /etc/hosts

2. **`_remove_host`**
  - Remove hostname from /etc/hosts

3. **`gcloud_init`**
  - Configure gcloud

4. **`_start_docker`**
  - Build and start container stack

5. **`_stop_docker`**
  - Stop container stack

6. **`_wait_for_postgres`**
  - Wait for postgresql to start

7. **`_wait_for_rabbit`**
  - Wait for rabbitmq to start

8. **`kill`**
  - Kill all runnnig containers

9. **`load_sql`**
  - Load local sql script

10. **`psql`**
  - Open postgres terminal in docker

11. **`status`**
  - Print docker status

### ⚡ Reflexion

1. **`_get_constants`**
  - List constants from provided shoe script

2. **`_get_constraint`**
  - List constaints from provided shoe script

3. **`_get_flags`**
  - List flags from provided shoe script

4. **`_get_function`**
  - Get function by name

5. **`_get_functions_names`**
  - List functions names from provided shoe script

6. **`_get_options`**
  - List options from provided shoe script

7. **`_collapse_blank_lines`**
  - Collapse blank lines with sed

### ⚡ Sytem

1. **`_check_installed`**
  - Print error message if provided command is missing

2. **`_generate_key`**
  - Generate random 32 bit string

3. **`_is_checksum_valid`**
  - Validate a file checksum

4. **`_is_installed`**
  - Check provided command is installed

5. **`_is_root`**
  - Check user is root

6. **`_pwd`**
  - Return current project directory path, or "pwd" when installed globally

7. **`_require`**
  - Install required command

8. **`__require`**

9. **`_sed_flavor`**
  - Get sed flavour

10. **`_user_exists`**
  - Check user exists

### ⚡ Validation

1. **`_is_valid`**
  - Checks if variable is valid given regex constraint

2. **`_validate`**
  - Find constraints and validates a variable

3. **`_main`**
  - shoe-lg main function with hooks

