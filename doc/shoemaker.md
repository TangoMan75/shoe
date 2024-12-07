TangoMan Shoe Maker
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io> "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0 1.0.0
- link:    https://github.com/TangoMan75/shoe https://github.com/TangoMan75/shoe

## 📑 Description

A versatile developement tool to split a script file into its components build a shoe script from "build.lst" file or generate markdown documentation from a shoe script.    TangoMan shoe  Run "make" to print help If you want to add a help message for your rule,  just add : "## My help for this rule", on the previous line use : "### " to group rules by categories You can give "make" arguments with this syntax: PARAMETER=VALUE   

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

5. **`generate_doc`**
  - Generate Markdown documentation for provided shoe script

6. **`generate_doc_all`**
  - Generate Markdown documentation for all scripts

7. **`generate_makefile`**
  - Generate Markdown documentation for provided shoe script

8. **`generate_makefile_all`**
  - Generate Makefile for all scripts

9. **`_build`**
  - Build from given "build.lst" file

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

3. **`_get_comspec`**
  - Generate comspec string

4. **`_copy_install`**
  - Install script via copy (beta)

5. **`_remove_completion_autoload`**
  - Remove completion script autoload

6. **`_generate_autocomplete`**
  - Generates an autocomplete script for the provided file.

7. **`_set_completion_autoload`**
  - Adds an autoload line for completion script to a shell configuration file.

8. **`__set_completion_autoload`**

9. **`_generate_global_autocomplete`**
  - Creates a system-wide autocomplete script for the provided file.

10. **`_symlink_install`**
  - Install script via symlink

11. **`_uninstall`**
  - Uninstall script from system

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

8. **`_print_options`**
  - List options of the of the current shoe script

9. **`_print_commands`**
  - List commands of the of the current shoe script

### ⚡ Docbloc

1. **`_get_docbloc`**
  - Get docbloc at the top the provided shoe script file

2. **`_get_docbloc_description`**
  - Get docbloc description at the top the provided shoe script file

3. **`_get_docbloc_title`**
  - Get docbloc title at the top the provided shoe script file

### ⚡ Documentation

1. **`_generate_doc`**
  - Generate Markdown documentation for provided shoe script

### ⚡ System compatibility

1. **`_open`**
  - Open with default handler

2. **`_sed_i`**
  - Return sed -i system flavour

### ⚡ Makefile

1. **`_generate_makefile`**
  - Generate Makefile documentation for provided shoe script

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

8. **`_main`**
  - shoe-lg main function with hooks

