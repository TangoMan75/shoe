TangoMan Shoemaker
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0
- link:    https://github.com/TangoMan75/shoe

## 📑 Description

A versatile developement tool to split a script file into its components build a script from build.lst file, generate Makefile or markdown documentation from a shoe script.  

## 🔥 Usage

`sh shoemaker.sh [command] (--file '') (--destination '') (--type shell) (--private)`

## 🚩 Flags

1. **`--private`**
> Document private elements

<br>

## ⚙️ Options

1. **`private`**
> Document private elements
  - Default: _false_

<br>

## 🤖 Commands

1. **`dump`**
> Dump functions

<br>

2. **`list`**
> Dump "build.lst" file

<br>

3. **`build`**
> Build from given "build.lst" file

<br>

4. **`build_all`**
> Build all scripts

<br>

### ⚡ Documentation

1. **`generate_doc`**
> Generate Markdown documentation for provided shoe script

<br>

2. **`generate_doc_all`**
> Generate Markdown documentation for all scripts

<br>

### ⚡ Makefile

1. **`generate_makefile`**
> Generate Markdown documentation for provided shoe script

<br>

2. **`generate_makefile_all`**
> Generate Makefile for all scripts

<br>

3. **`_build` (private)**
> Build from given "build.lst" file

<br>

### ⚡ Self Install

1. **`self_install`**
> Install script and enable completion

<br>

2. **`self_uninstall`**
> Uninstall script from system

<br>

3. **`self_update`**
> Update script from @update-link

<br>

### ⚡ Help

1. **`help`**
> Print this help

<br>

### ⚡ Hooks

1. **`_default` (private)**
> Place here commands you need executed by default (optional)

<br>

2. **`_before` (private)**
> Place here commands you need executed first every time (optional)

<br>

3. **`_after` (private)**
> Place here commands you need executed last every time (optional)

<br>

### ⚡ Colors

1. **`echo_primary` (private)**
> Print primary text with optional indentation and padding

<br>

2. **`echo_secondary` (private)**
> Print secondary text with optional indentation and padding

<br>

3. **`echo_success` (private)**
> Print success text with optional indentation and padding

<br>

4. **`echo_danger` (private)**
> Print danger text with optional indentation and padding

<br>

5. **`echo_warning` (private)**
> Print warning text with optional indentation and padding

<br>

6. **`echo_info` (private)**
> Print info text with optional indentation and padding

<br>

7. **`echo_light` (private)**
> Print light text with optional indentation and padding

<br>

8. **`echo_dark` (private)**
> Print dark text with optional indentation and padding

<br>

9. **`alert_primary` (private)**
> Print primary alert

<br>

10. **`alert_secondary` (private)**
> Print secondary alert

<br>

11. **`alert_success` (private)**
> Print success alert

<br>

12. **`alert_danger` (private)**
> Print danger alert

<br>

13. **`alert_warning` (private)**
> Print warning alert

<br>

14. **`alert_info` (private)**
> Print info alert

<br>

15. **`alert_light` (private)**
> Print light alert

<br>

16. **`alert_dark` (private)**
> Print dark alert

<br>

### ⚡ System compatibility

1. **`_sed_i` (private)**
> Return sed -i system flavour

<br>

### ⚡ Docbloc

1. **`_get_docbloc` (private)**
> Parse docbloc at the top the provided shoe script file

<br>

2. **`_get_docbloc_description` (private)**
> Get docbloc description at the top the provided shoe script file

<br>

3. **`_get_docbloc_title` (private)**
> Get docbloc title at the top the provided shoe script file

<br>

### ⚡ Documentation

1. **`_generate_doc` (private)**
> Generate Markdown documentation for provided shoe script

<br>

### ⚡ Help

1. **`_help` (private)**
> Print help for provider shoe script

<br>

2. **`_print_commands` (private)**
> List commands of the of the current shoe script (used by "help" command)

<br>

3. **`_print_constants` (private)**
> List constants of the of the current shoe script (used by "help" command)

<br>

4. **`_print_description` (private)**
> Print provided text formatted as a description (used by "help" command)

<br>

5. **`_print_flags` (private)**
> List flags of the of the current shoe script (used by "help" command)

<br>

6. **`_print_infos` (private)**
> Print infos of the of the current shoe script (used by "help" command)

<br>

7. **`_print_options` (private)**
> List options of the of the current shoe script (used by "help" command)

<br>

8. **`_print_usage` (private)**
> Print usage of the of the current shoe script (used by "help" command)

<br>

### ⚡ Install

1. **`_copy_install` (private)**
> Install script via copy

<br>

2. **`_generate_autocomplete` (private)**
> Generates an autocomplete script for the provided file

<br>

3. **`_generate_global_autocomplete` (private)**
> Creates a system-wide autocomplete script for the provided file

<br>

4. **`_get_comspec` (private)**
> Generate comspec string for the provided file

<br>

5. **`_install` (private)**
> Install script and enable completion

<br>

6. **`_remove_completion_autoload` (private)**
> Remove completion script autoload

<br>

7. **`_set_completion_autoload` (private)**
> Adds an autoload line for completion script to a shell configuration file

<br>

8. **`_symlink_install` (private)**
> Install script via symlink

<br>

9. **`_uninstall` (private)**
> Uninstall script from system

<br>

10. **`_update` (private)**
> Updates given script from the provided URL

<br>

### ⚡ Makefile

1. **`_generate_makefile` (private)**
> Generate Makefile for provided shoe script

<br>

### ⚡ Reflexion

1. **`_get_constants` (private)**
> List constants from provided shoe script

<br>

2. **`_get_constraint` (private)**
> List constaints from provided shoe script

<br>

3. **`_get_flags` (private)**
> List flags from provided shoe script

<br>

4. **`_get_function` (private)**
> Get function by name

<br>

5. **`_get_functions_names` (private)**
> List functions names from provided shoe script

<br>

6. **`_get_options` (private)**
> List options from provided shoe script

<br>

7. **`_get_padding` (private)**
> Guess padding length from longest constant, option, flag or command of the provided shoe script

<br>

8. **`_collapse_blank_lines` (private)**
> Collapse blank lines with "sed"

<br>

### ⚡ Sytem

1. **`_check_installed` (private)**
> Print error message if provided command is missing

<br>

2. **`_is_installed` (private)**
> Check provided command is installed

<br>

3. **`_pwd` (private)**
> Return current project directory path, or "pwd" when installed globally

<br>

### ⚡ Validation

1. **`_is_valid` (private)**
> Checks if variable is valid given regex constraint

<br>

2. **`_validate` (private)**
> Find constraints and validates a variable

<br>

### ⚡ kernel

1. **`_kernel` (private)**
> Shoe Kernel

<br>

