TangoMan Shoe
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0
- link:    https://github.com/TangoMan75/shoe

## 📑 Description

Simplify your shell scripting workflow with self-documenting shell scripts with robust argument validation. Just prefix a comment with two pound signs (##) on the line above any function or variable to generate helpful documentation using the "help" command.  Features:   - [X] colors   - [X] commands   - [X] private functions   - [X] help   - [X] docbloc   - [X] options + validation   - [X] flags   - [X] install + autocomplete + update   - [X] compatibility   - [X] documentation   - [X] makefile  Warning: Functions and variables names should not contain dashes.    $(_get_docbloc_title "$1")  $(_get_docbloc_description "$1")   

## 🔥 Usage

`sh shoe.sh [command] (--who "World") (--flag) (--global)`

## 🧱 Constants

1. **ALIAS**
  - Script alias (the command alias that will be used for invoking the script after installation)
  - Value: _shoe_

2. **_PRIVATE**
  - This constant is private (it will not show up in the help section)
  - Value: _"I'm a private constant"_

## 🚩 Flags

1. **`--flag`**
  - Example Flag (any variable set to "false" will convert to a flag at runtime)

2. **`--global`**
  - Install script globally

## ⚙️ Options

1. **`--who`**
  - Description: Greeting recipient name 
  - Constraint: `/^[a-zA-Z-]+$/`
  - Default: _"World"_

2. **`--_global_variable`**
  - Description: This variable is private (it will not show up as an option in the help section)
  - Default: _"I'm a global variable"_

## 🤖 Commands

1. **`hello`**
  - Greets a specified recipient (the recipient's name is provided with the "--who" option)

2. **`flag_test`**
  - Prints flag status

3. **`_private`**
  - Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.

### ⚡ Self Install

1. **`self_install`**
  - Install script and enable completion

2. **`self_uninstall`**
  - Uninstall script from system

3. **`self_update`**
  - Update script from @update-link

### ⚡ Documentation

1. **`generate_doc`**
  - Generate Markdown documentation for current shoe script

### ⚡ Makefile

1. **`generate_makefile`**
  - Generate Makefile for current shoe script

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

1. **`_open`**
  - Open with default system handler

2. **`_sed_i`**
  - Return sed -i system flavour

### ⚡ Docbloc

1. **`_get_docbloc`**
  - Parse docbloc at the top the provided shoe script file

2. **`_get_docbloc_description`**
  - Get docbloc description at the top the provided shoe script file

3. **`_get_docbloc_title`**
  - Get docbloc title at the top the provided shoe script file

### ⚡ Docker

1. **`_docker_compose_start`**
  - Build and start container stack with docker-compose

2. **`_docker_compose_stop`**
  - Stop container stack with docker-compose

3. **`_docker_container_is_running`**
  - Is container running

4. **`_docker_kill_all`**
  - Kill all running containers with docker

5. **`_docker_load_sql`**
  - Load local sql script

6. **`_docker_psql`**
  - Open postgres terminal in docker

7. **`_docker_status`**
  - Print docker status

8. **`_docker_wait_for_postgres`**
  - Wait for postgresql container to start with docker

9. **`_docker_wait_for_rabbit`**
  - Wait for rabbitmq container to start with docker

### ⚡ Documentation

1. **`_generate_doc`**
  - Generate Markdown documentation for provided shoe script

### ⚡ Git

1. **`_git_hooks`**
  - Install git hooks

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

### ⚡ Network

1. **`_gcloud_init`**
  - Configure gcloud

2. **`_remove_host`**
  - Remove hostname from /etc/hosts

3. **`_set_host`**
  - Set new host in /etc/hosts

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

8. **`_get_parameter`**
  - Get value for given parameter from provided ".env" or ".sh" file

9. **`_set_parameter`**
  - Set value for given parameter into provided file ".env" or ".sh" file

10. **`_collapse_blank_lines`**
  - Collapse blank lines with "sed"

11. **`_generate_key`**
  - Generate random 32 bit string

### ⚡ Sytem

1. **`_check_installed`**
  - Print error message if provided command is missing

2. **`_is_checksum_valid`**
  - Validate a file checksum

3. **`_is_installed`**
  - Check provided command is installed

4. **`_is_root`**
  - Check user is root

5. **`_pwd`**
  - Return current project directory path, or "pwd" when installed globally

6. **`_require`**
  - Install required command

7. **`_user_exists`**
  - Check user exists

### ⚡ Validation

1. **`_is_valid`**
  - Checks if variable is valid given regex constraint

2. **`_validate`**
  - Find constraints and validates a variable

### ⚡ Main function

1. **`_main`**
  - shoe main function

