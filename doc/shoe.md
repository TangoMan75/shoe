TangoMan Shoe
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0
- link:    https://github.com/TangoMan75/shoe

## 📑 Description

Simplify your shell scripting workflow with self-documenting shell scripts with robust argument validation. Just prefix a comment with two pound signs (##) on the line above any function or variable to generate helpful documentation using the "help" command.  Warning: Functions and variables names should not contain dashes.  

## 🔥 Usage

`sh shoe.sh [command] (--who "World") (--count 1) (--flag) (--global)`

## 🧱 Constants

1. **ALIAS**
> Script alias (the command alias that will be used for invoking the script after installation)
  - Value: _shoe_

<br>

2. **_PRIVATE (private)**
> This constant is private (it will not de displayed in the "help" output)
  - Value: _"I'm a private constant"_

<br>

## ⚙️ Global Variables

1. **`_global_variable` (private)**
> This variable is private (it will not de displayed in the "help" output)
  - Default: _"I'm a global variable"_

<br>

## 🚩 Flags

1. **`--flag`**
> Example Flag (any variable set to "false" will convert to a flag at runtime)

<br>

2. **`--global`**
> Install script globally

<br>

## ⚙️ Options

1. **`flag`**
> Example Flag (any variable set to "false" will convert to a flag at runtime)
  - Default: _false_

<br>

2. **`global`**
> Install script globally
  - Default: _false_

<br>

## 🤖 Commands

1. **`hello`**
> Greets a specified recipient a given number of times (the recipient's name is provided with the "--who" option)

<br>

2. **`flag_test`**
> Prints flag status

<br>

3. **`_private` (private)**
> Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.

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

### ⚡ Documentation

1. **`generate_doc`**
> Generate Markdown documentation for current shoe script

<br>

### ⚡ Makefile

1. **`generate_makefile`**
> Generate Makefile for current shoe script

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

1. **`_open` (private)**
> Open with default system handler

<br>

2. **`_sed_i` (private)**
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

### ⚡ Docker

1. **`_docker_compose_start` (private)**
> Build and start container stack with docker-compose

<br>

2. **`_docker_compose_stop` (private)**
> Stop container stack with docker-compose

<br>

3. **`_docker_container_is_running` (private)**
> Is container running

<br>

4. **`_docker_kill_all` (private)**
> Kill all running containers with docker

<br>

5. **`_docker_load_sql` (private)**
> Load local sql script

<br>

6. **`_docker_psql` (private)**
> Open postgres terminal in docker

<br>

7. **`_docker_status` (private)**
> Print docker status

<br>

8. **`_docker_wait_for_postgres` (private)**
> Wait for postgresql container to start with docker

<br>

9. **`_docker_wait_for_rabbit` (private)**
> Wait for rabbitmq container to start with docker

<br>

### ⚡ Documentation

1. **`_generate_doc` (private)**
> Generate Markdown documentation for provided shoe script

<br>

### ⚡ Git

1. **`_git_hooks` (private)**
> Install git hooks

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

### ⚡ Network

1. **`_gcloud_init` (private)**
> Configure gcloud

<br>

2. **`_remove_host` (private)**
> Remove hostname from /etc/hosts

<br>

3. **`_set_host` (private)**
> Set new host in /etc/hosts

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

8. **`_get_parameter` (private)**
> Get value for given parameter from provided ".env" or ".sh" file

<br>

9. **`_set_parameter` (private)**
> Set value for given parameter into provided file ".env" or ".sh" file

<br>

10. **`_collapse_blank_lines` (private)**
> Collapse blank lines with "sed"

<br>

11. **`_generate_key` (private)**
> Generate random 32 bit string

<br>

### ⚡ Sytem

1. **`_check_installed` (private)**
> Print error message if provided command is missing

<br>

2. **`_is_checksum_valid` (private)**
> Validate a file checksum

<br>

3. **`_is_installed` (private)**
> Check provided command is installed

<br>

4. **`_is_root` (private)**
> Check current user is root

<br>

5. **`_pwd` (private)**
> Return current project directory path, or "pwd" when installed globally

<br>

6. **`_require` (private)**
> Install required command

<br>

7. **`_user_exists` (private)**
> Check provided user exists

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

