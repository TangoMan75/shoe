TangoMan Shoe Maker
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0
- link:    https://github.com/TangoMan75/shoe

## 📑 Description

A versatile developement tool to split a script file into its components build a shoe script from "build.lst" file or generate markdown documentation from a shoe script.    $(_get_docbloc_title "$1")  $(_get_docbloc_description "$1")   

## 🔥 Usage

`sh shoemaker.sh [command] (--file '') (--destination '') (--type shell) (--private)`

## 🚩 Flags

1. **`--private`**
  - Document private elements

## ⚙️ Options

1. **`--file`**
  - Description: Source file 
  - Constraint: `/~?[a-zA-Z0-9./_-]+/`
  - Default: _''_

2. **`--destination`**
  - Description: Destination directory 
  - Constraint: `/~?[a-zA-Z0-9/._-]+/`
  - Default: _''_

3. **`--type`**
  - Description: Script type 
  - Constraint: `/(shell|bash)/`
  - Default: _shell_

## 🤖 Commands

1. **`dump`**
  - Dump functions

2. **`list`**
  - Dump "build.lst" file

3. **`build`**
  - Build from given "build.lst" file

4. **`build_all`**
  - Build all scripts

### ⚡ Documentation

1. **`generate_doc`**
  - Generate Markdown documentation for provided shoe script

2. **`generate_doc_all`**
  - Generate Markdown documentation for all scripts

### ⚡ Makefile

1. **`generate_makefile`**
  - Generate Markdown documentation for provided shoe script

2. **`generate_makefile_all`**
  - Generate Makefile for all scripts

3. **`_build`**
  - Build from given "build.lst" file

### ⚡ Self Install

1. **`self_install`**
  - Install script and enable completion

2. **`self_uninstall`**
  - Uninstall script from system

3. **`self_update`**
  - Update script from @update-link

### ⚡ Help

1. **`help`**
  - Print help for current shoe script (default)

### ⚡ Hooks

1. **`_default`**
  - Place here commands you need executed by default

2. **`_before`**
  - Place here commands you need executed first every time

3. **`_after`**
  - Place here commands you need executed last every time

### ⚡ Colors

1. **`echo_primary`**
  - Print primary text with optional indentation and padding

2. **`echo_secondary`**
  - Print secondary text with optional indentation and padding

3. **`echo_success`**
  - Print success text with optional indentation and padding

4. **`echo_danger`**
  - Print danger text with optional indentation and padding

5. **`echo_warning`**
  - Print warning text with optional indentation and padding

6. **`echo_info`**
  - Print info text with optional indentation and padding

7. **`echo_light`**
  - Print light text with optional indentation and padding

8. **`echo_dark`**
  - Print dark text with optional indentation and padding

9. **`alert_primary`**
  - Print primary alert

10. **`alert_secondary`**
  - Print secondary alert

11. **`alert_success`**
  - Print success alert

12. **`alert_danger`**
  - Print danger alert

13. **`alert_warning`**
  - Print warning alert

14. **`alert_info`**
  - Print info alert

15. **`alert_light`**
  - Print light alert

16. **`alert_dark`**
  - Print dark alert

### ⚡ System compatibility

1. **`_sed_i`**
  - Return sed -i system flavour

### ⚡ Docbloc

1. **`_get_docbloc`**
  - Parse docbloc at the top the provided shoe script file

2. **`_get_docbloc_description`**
  - Get docbloc description at the top the provided shoe script file

3. **`_get_docbloc_title`**
  - Get docbloc title at the top the provided shoe script file

### ⚡ Documentation

1. **`_generate_doc`**
  - Generate Markdown documentation for provided shoe script

### ⚡ Help

1. **`_help`**
  - Print help for provider shoe script

2. **`_print_commands`**
  - List commands of the of the current shoe script (used by "help" command)

3. **`_print_constants`**
  - List constants of the of the current shoe script (used by "help" command)

4. **`_print_description`**
  - Print provided text formatted as a description (used by "help" command)

5. **`_print_flags`**
  - List flags of the of the current shoe script (used by "help" command)

6. **`_print_infos`**
  - Print infos of the of the current shoe script (used by "help" command)

7. **`_print_options`**
  - List options of the of the current shoe script (used by "help" command)

8. **`_print_usage`**
  - Print usage of the of the current shoe script (used by "help" command)

### ⚡ Install

1. **`_copy_install`**
  - Install script via copy

2. **`_generate_autocomplete`**
  - Generates an autocomplete script for the provided file.

3. **`_generate_global_autocomplete`**
  - Creates a system-wide autocomplete script for the provided file.

4. **`_get_comspec`**
  - Generate comspec string

5. **`_install`**
  - Install script and enable completion

6. **`_remove_completion_autoload`**
  - Remove completion script autoload

7. **`_set_completion_autoload`**
  - Adds an autoload line for completion script to a shell configuration file.

8. **`_symlink_install`**
  - Install script via symlink

9. **`_uninstall`**
  - Uninstall script from system

10. **`_update`**
  - Updates given script from the provided URL.

### ⚡ Makefile

1. **`_generate_makefile`**
  - Generate Makefile for provided shoe script

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

7. **`_get_padding`**
  - Guess padding length from longest constant, option, flag or command of the provided shoe script

8. **`_collapse_blank_lines`**
  - Collapse blank lines with "sed"

### ⚡ Sytem

1. **`_check_installed`**
  - Print error message if provided command is missing

2. **`_is_installed`**
  - Check provided command is installed

3. **`_pwd`**
  - Return current project directory path, or "pwd" when installed globally

### ⚡ Validation

1. **`_is_valid`**
  - Checks if variable is valid given regex constraint

2. **`_validate`**
  - Find constraints and validates a variable

### ⚡ Main function

1. **`_main`**
  - shoe main function

