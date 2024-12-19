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

2. **_PRIVATE (private)**
> This constant is private (it will not de displayed in the "help" output)
  - Value: _"I'm a private constant"_

3. **PRIMARY (private)**
> PRIMARY: bright white text
  - Value: _'\033[97m'_

4. **SECONDARY (private)**
> SECONDARY: bright blue text
  - Value: _'\033[94m'_

5. **SUCCESS (private)**
> SUCCESS: bright green text
  - Value: _'\033[32m'_

6. **DANGER (private)**
> DANGER: red text
  - Value: _'\033[31m'_

7. **WARNING (private)**
> WARNING: orange text
  - Value: _'\033[33m'_

8. **INFO (private)**
> INFO: bright purple text
  - Value: _'\033[95m'_

9. **LIGHT (private)**
> LIGHT: black text over white background
  - Value: _'\033[47;90m'_

10. **DARK (private)**
> DARK: white text over black background
  - Value: _'\033[40;37m'_

11. **DEFAULT (private)**
> DEFAULT: reset formatting
  - Value: _'\033[0m'_

12. **EOL (private)**
> EOF: reset formatting and carriage return
  - Value: _'\033[0m\n'_

13. **ALERT_PRIMARY (private)**
> ALERT_PRIMARY: bold white text over bright blue background
  - Value: _'\033[1;104;97m'_

14. **ALERT_SECONDARY (private)**
> ALERT_SECONDARY: bold white text over bright purple background
  - Value: _'\033[1;45;97m'_

15. **ALERT_SUCCESS (private)**
> ALERT_SUCCESS: bold white text over bright green background
  - Value: _'\033[1;42;97m'_

16. **ALERT_DANGER (private)**
> ALERT_DANGER: bold white text over bright red background
  - Value: _'\033[1;41;97m'_

17. **ALERT_WARNING (private)**
> ALERT_WARNING: bold white text over bright orange background
  - Value: _'\033[1;43;97m'_

18. **ALERT_INFO (private)**
> ALERT_INFO: bold white text over bright blue background
  - Value: _'\033[1;44;97m'_

19. **ALERT_LIGHT (private)**
> ALERT_LIGHT: bold grey text over white background
  - Value: _'\033[1;47;90m'_

20. **ALERT_DARK (private)**
> ALERT_DARK: bold white text over black background
  - Value: _'\033[1;40;37m'_

## ⚙️ Global Variables

1. **`_global_variable` (private)**
> This variable is private (it will not de displayed in the "help" output)
  - Default: _"I'm a global variable"_

## 🚩 Flags

1. **`--flag`**
> Example Flag (any variable set to "false" will convert to a flag at runtime)

2. **`--global`**
> Install script globally

## ⚙️ Options

1. **`--who`**
> Greeting recipient name 
  - Constraint: `/^[a-zA-Z-]+$/`
  - Default: _"World"_

2. **`--count`**
> How many times to say hello 
  - Constraint: `/[1-9]/`
  - Default: _1_

## 🤖 Commands

#### 1. `hello`

Greets a specified recipient a given number of times (the recipient's name is provided with the "--who" option)

#### 2. `flag_test`

Prints flag status

#### 3. `_private` (private)

Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.

### ⚡ Self Install

#### 1. `self_install`

Install script and enable completion

#### 2. `self_uninstall`

Uninstall script from system

#### 3. `self_update`

Update script from @update-link

### ⚡ Documentation

#### 1. `generate_doc`

Generate Markdown documentation for current shoe script

### ⚡ Makefile

#### 1. `generate_makefile`

Generate Makefile for current shoe script

### ⚡ Help

#### 1. `help`

Print this help

### ⚡ Hooks

#### 1. `_default` (private)

Place here commands you need executed by default (optional)

#### 2. `_before` (private)

Place here commands you need executed first every time (optional)

#### 3. `_after` (private)

Place here commands you need executed last every time (optional)

### ⚡ Colors

#### 1. `echo_primary` (private)

Print primary text with optional indentation and padding
> Synopsis: echo_primary \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 2. `echo_secondary` (private)

Print secondary text with optional indentation and padding
> Synopsis: echo_secondary \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 3. `echo_success` (private)

Print success text with optional indentation and padding
> Synopsis: echo_success \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 4. `echo_danger` (private)

Print danger text with optional indentation and padding
> Synopsis: echo_danger \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 5. `echo_warning` (private)

Print warning text with optional indentation and padding
> Synopsis: echo_warning \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 6. `echo_info` (private)

Print info text with optional indentation and padding
> Synopsis: echo_info \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 7. `echo_light` (private)

Print light text with optional indentation and padding
> Synopsis: echo_light \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 8. `echo_dark` (private)

Print dark text with optional indentation and padding
> Synopsis: echo_dark \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 9. `alert_primary` (private)

Print primary alert
> Synopsis: alert_primary \<STRING\><br>
>   STRING: Text to display.<br>

#### 10. `alert_secondary` (private)

Print secondary alert
> Synopsis: alert_secondary \<STRING\><br>
>   STRING: Text to display.<br>

#### 11. `alert_success` (private)

Print success alert
> Synopsis: alert_success \<STRING\><br>
>   STRING: Text to display.<br>

#### 12. `alert_danger` (private)

Print danger alert
> Synopsis: alert_danger \<STRING\><br>
>   STRING: Text to display.<br>

#### 13. `alert_warning` (private)

Print warning alert
> Synopsis: alert_warning \<STRING\><br>
>   STRING: Text to display.<br>

#### 14. `alert_info` (private)

Print info alert
> Synopsis: alert_info \<STRING\><br>
>   STRING: Text to display.<br>

#### 15. `alert_light` (private)

Print light alert
> Synopsis: alert_light \<STRING\><br>
>   STRING: Text to display.<br>

#### 16. `alert_dark` (private)

Print dark alert
> Synopsis: alert_dark \<STRING\><br>
>   STRING: Text to display.<br>

### ⚡ System compatibility

#### 1. `_open` (private)

Open with default system handler
> Synopsis: _open<br>

#### 2. `_sed_i` (private)

Return sed -i system flavour
> Synopsis: _sed_i<br>

### ⚡ Docbloc

#### 1. `_get_docbloc` (private)

Parse docbloc at the top the provided shoe script file
> Synopsis: _get_docbloc \<FILE_PATH\> <TAG_NAME><br>
>   FILE_PATH:  The path to the input file.<br>
>   TAG_NAME:   The name of the docbloc parameter to return.<br>
>   note:       To change displayed items, edit docblock infos at the top of the file.<br>

#### 2. `_get_docbloc_description` (private)

Get docbloc description at the top the provided shoe script file
> Synopsis: _get_docbloc_description \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>
>   note:       To change displayed items, edit docblock infos at the top of the file.<br>

#### 3. `_get_docbloc_title` (private)

Get docbloc title at the top the provided shoe script file
> Synopsis: _get_docbloc_title \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>
>   note:       To change displayed items, edit docblock infos at the top of the file.<br>

### ⚡ Docker

#### 1. `_docker_compose_start` (private)

Build and start container stack with docker-compose
> Synopsis: _docker_compose_start<br>

#### 2. `_docker_compose_stop` (private)

Stop container stack with docker-compose
> Synopsis: _docker_compose_stop<br>

#### 3. `_docker_container_is_running` (private)

Is container running
> Synopsis: _is_running \<CONTAINER_NAME\><br>
>   CONTAINER_NAME:  The name of the docker container.<br>

#### 4. `_docker_kill_all` (private)

Kill all running containers with docker
> Synopsis: _docker_kill_all<br>

#### 5. `_docker_load_sql` (private)

Load local sql script
> Synopsis: _docker_load_sql \<CONTAINER_NAME\> <FILE_PATH><br>
>   CONTAINER_NAME:  The name of the docker container.<br>
>   FILE_PATH:       The path to the sql file.<br>

#### 6. `_docker_psql` (private)

Open postgres terminal in docker
> Synopsis: _docker_psql \<CONTAINER_NAME\><br>
>   CONTAINER_NAME:  The name of the docker container.<br>

#### 7. `_docker_status` (private)

Print docker status
> Synopsis: _docker_status<br>

#### 8. `_docker_wait_for_postgres` (private)

Wait for postgresql container to start with docker
> Synopsis: _docker_wait_for_postgres \<CONTAINER_NAME\> [USERNAME]<br>
>   CONTAINER_NAME:  The name of the docker container.<br>
>   USERNAME:        (optional) The psql username. Defaults to "".<br>

#### 9. `_docker_wait_for_rabbit` (private)

Wait for rabbitmq container to start with docker
> Synopsis: _docker_wait_for_rabbit \<CONTAINER_NAME\><br>
>   CONTAINER_NAME:  The name of the docker container.<br>

### ⚡ Documentation

#### 1. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script
> Synopsis: _generate_doc \<INPUT_FILE_PATH\> [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]<br>
>   INPUT_FILE_PATH:   The path to the input file.<br>
>   DESTINATION:       (optional) The path to the destination folder. Defaults to file parent.<br>
>   OUTPUT_FILE_NAME:  (optional) The name for the documentation file. Defaults to "\<BASENAME\>.md".<br>
>   GET_PRIVATE:       (Optional) If set to 'true', documents private constants, options, flags, and commands as well. Defaults to "false".<br>

### ⚡ Files

#### 1. `_get_file_extension` (private)

Get file extension
> Synopsis: _get_file_extension \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>

### ⚡ Git

#### 1. `_git_hooks` (private)

Install git hooks
> Synopsis: _git_hooks<br>

#### 2. `_initialise_submodules` (private)

Initialise git submodules
> Synopsis: _initialise_submodules<br>

### ⚡ Help

#### 1. `_help` (private)

Print help for provider shoe script
> Synopsis: _help \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>

#### 2. `_print_commands` (private)

List commands of the of the current shoe script (used by "help" command)
> Synopsis: _print_commands [PADDING]<br>
>  PADDING:  (optional) Padding length (default: 12)<br>
>  note:     "awk: %*x formats are not supported"<br>

#### 3. `_print_constants` (private)

List constants of the of the current shoe script (used by "help" command)
> Synopsis: _print_constants [PADDING]<br>
>  PADDING:  (optional) Padding length (default: 12)<br>
>  note:     "awk: %*x formats are not supported"<br>

#### 4. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)
> Synopsis: _print_description \<DESCRIPTION\><br>
>   DESCRIPTION:  A string containing script description.<br>

#### 5. `_print_flags` (private)

List flags of the of the current shoe script (used by "help" command)
> Synopsis: _print_flags [PADDING]<br>
>  PADDING:  (optional) Padding length (default: 12)<br>
>  note:     "awk: %*x formats are not supported"<br>

#### 6. `_print_infos` (private)

Print infos of the of the current shoe script (used by "help" command)
> Synopsis: _print_infos<br>

#### 7. `_print_options` (private)

List options of the of the current shoe script (used by "help" command)
> Synopsis: _print_options [PADDING]<br>
>  PADDING:  (optional) Padding length (default: 12)<br>
>  note:     "awk: %*x formats are not supported"<br>

#### 8. `_print_usage` (private)

Print usage of the of the current shoe script (used by "help" command)
> Synopsis: _print_usage<br>

### ⚡ Install

#### 1. `_copy_install` (private)

Install script via copy
> Synopsis: _copy_install \<FILE_PATH\> [ALIAS]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file<br>
>   note:       Creates a symbolic link in the /usr/local/bin/ directory.<br>

#### 2. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file
> Synopsis: _generate_autocomplete \<FILE_PATH\> [ALIAS]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file<br>
>   note:       This function creates a completion script named "\<ALIAS\>-completion.sh" in the same directory as the script itself.<br>
>               Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.<br>
>               Or read the official docmentation for "complete" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins<br>

#### 3. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file
> Synopsis: _generate_global_autocomplete \<FILE_PATH\> [ALIAS]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file<br>
>   note:       This function creates a completion script named "\<ALIAS\>" (where "<ALIAS>" is the basename of the provided file)<br>
>               in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.<br>
>               It uses sudo for file creation in a system directory, requiring root privileges.<br>

#### 4. `_get_comspec` (private)

Generate comspec string for the provided file
> Synopsis: _get_comspec \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>

#### 5. `_install` (private)

Install script and enable completion
> Synopsis: _install \<FILE_PATH\> [ALIAS] [GLOBAL]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided script.<br>
>   GLOBAL:     (optional) Install globally. Defaults to "false".<br>

#### 6. `_remove_completion_autoload` (private)

Remove completion script autoload
> Synopsis: _remove_completion_autoload \<SHELL_CONFIG_FILE\> [ALIAS]<br>
> Removes an autoload line for a completion script from a shell configuration file.<br>
>   SHELL_CONFIG_FILE:  The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).<br>
>   ALIAS:              (optional) The alias of the script to remove. Defaults to the basename of the provided file<br>

#### 7. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file
> Synopsis: _set_completion_autoload \<SHELL_CONFIG_FILE_PATH\> <SCRIPT_FILE_PATH> [ALIAS]<br>
>   SHELL_CONFIG_FILE_PATH:  The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).<br>
>   SCRIPT_FILE_PATH:        The path to the input file.<br>
>   ALIAS:                   (optional) The alias of the input script. Defaults to the basename of the provided file<br>

#### 8. `_symlink_install` (private)

Install script via symlink
> Synopsis: _symlink_install \<FILE_PATH\> [ALIAS]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file<br>
>   note:       Creates a symbolic link in the /usr/local/bin/ directory.<br>

#### 9. `_uninstall` (private)

Uninstall script from system
> Synopsis: _uninstall \<FILE_PATH\> [ALIAS]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to uninstall. Defaults to the basename of the provided script.<br>

#### 10. `_update` (private)

Updates given script from the provided URL
> Synopsis: _update \<FILE_PATH\> <URL> [ALIAS] [GLOBAL]<br>
>   FILE_PATH:  The path to the input file.<br>
>   URL:        The URL of the script to download and install.<br>
>   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided script.<br>
>   GLOBAL:     (optional) Install globally. Defaults to "false".<br>

### ⚡ Makefile

#### 1. `_generate_makefile` (private)

Generate Makefile for provided shoe script
> Synopsis: _generate_makefile \<INPUT_FILE_PATH\> [DESTINATION] [OUTPUT_FILE_NAME]<br>
>   INPUT_FILE_PATH:   The path to the input file.<br>
>   DESTINATION:       (optional) The path to the destination folder. Defaults to file parent.<br>
>   OUTPUT_FILE_NAME:  (optional) The name for the generated Makefile. Defaults to "\<BASENAME\>.makefile".<br>

### ⚡ Network

#### 1. `_open_in_default_browser` (private)

Open in default browser
> Synopsis: _open_in_default_browser [IP] [PORT]<br>
>   IP:    (optional) Target IP address or domain. (default=127.0.0.1)<br>
>   PORT:  (optional) Destination port. (default=8080)<br>

#### 2. `_php_serve` (private)

Serve given local directory with PHP
> Synopsis: _php_serve \<DOCROOT\> [IP] [PORT]<br>
>   DOCROOT: Target directory<br>
>   IP:      (optional) Local IP address. (default=127.0.0.1)<br>
>   PORT:    (optional) Destination port. (default=8080)<br>

#### 3. `_py_serve` (private)

Serve given local directory with Python 3
> Synopsis: _py_serve \<DOCROOT\> [IP] [PORT]<br>
>   DOCROOT: Target directory<br>
>   IP:      (optional) Local IP address. (default=127.0.0.1)<br>
>   PORT:    (optional) Destination port. (default=8080)<br>

#### 4. `_remove_host` (private)

Remove hostname from /etc/hosts
> Synopsis: remove_host \<HOSTNAME\><br>
>   HOSTNAME:  The hostame to unset locally.<br>

#### 5. `_set_host` (private)

Set new host in /etc/hosts
> Synopsis: set_host \<HOSTNAME\><br>
>   HOSTNAME:  The hostame to set locally.<br>

### ⚡ Prompts

#### 1. `_select` (private)

Present user with a list of choices and prompt them to select one
> Synopsis: _select \<CHOICES\><br>
>   CHOICES:  Array containing choices<br>

#### 2. `_yes_no` (private)

Promt user for yes or no

### ⚡ Reflexion

#### 1. `_get_constants` (private)

List constants from provided shoe script
> Synopsis: _get_constants \<SCRIPT_PATH\> [GET_PRIVATE]<br>
>   SCRIPT_PATH: The path to the input script.<br>
>   GET_PRIVATE: (Optional) If set to 'true', retrieves private constants as well. (default=false)<br>

#### 2. `_get_constraint` (private)

List constaints from provided shoe script
> Synopsis: _get_constraint \<SCRIPT_PATH\> <VARIABLE_NAME><br>
>   SCRIPT_PATH:   The path to the input script.<br>
>   VARIABLE_NAME: The variable to validate.<br>

#### 3. `_get_flags` (private)

List flags from provided shoe script
> Synopsis: _get_flags \<SCRIPT_PATH\><br>
>   SCRIPT_PATH: The path to the input script.<br>

#### 4. `_get_function` (private)

Get function by name
> Synopsis: _get_function \<SCRIPT_PATH\> <FUNCTION_NAME><br>
>   SCRIPT_PATH:   The path to the input file.<br>
>   FUNCTION_NAME: The name of the function to retrieve.<br>

#### 5. `_get_functions_names` (private)

List functions names from provided shoe script
> Synopsis: _get_functions_names \<SCRIPT_PATH\> [GET_PRIVATE]<br>
>   SCRIPT_PATH: The path to the input script.<br>
>   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".<br>

#### 6. `_get_options` (private)

List options from provided shoe script
> Synopsis: _get_options \<SCRIPT_PATH\> [GET_PRIVATE_ONLY]<br>
>   SCRIPT_PATH:      The path to the input script.<br>
>   GET_PRIVATE_ONLY: (Optional) If set to 'true', retrieves private options only. Defaults to "false".<br>

#### 7. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script
> Synopsis: _get_padding \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>

#### 8. `_get_parameter` (private)

Get value for given parameter from provided ".env" or ".sh" file
> Synopsys : _get_parameter \<FILE_PATH\> <KEY><br>
>   FILE_PATH:  The path to the input script.<br>
>   KEY:        The variable name to get from provided script<br>

#### 9. `_set_parameter` (private)

Set value for given parameter into provided file ".env" or ".sh" file
> Synopsys : _set_parameter \<FILE_PATH\> <KEY> <VALUE><br>
>   FILE_PATH:  The path to the input script.<br>
>   KEY:        The variable name to set to provided file<br>
>   VALUE:      The value to be set to provided file<br>

#### 10. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"
> Synopsis: _collapse_blank_lines \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>

#### 11. `_generate_key` (private)

Generate random 32 bit string
> Synopsis: _generate_key<br>

### ⚡ Sytem

#### 1. `_check_installed` (private)

Print error message if provided command is missing
> Synopsis: _check_installed \<COMMAND\><br>
>   COMMAND:  A string containing command name.<br>

#### 2. `_is_checksum_valid` (private)

Validate a file checksum
> Synopsis: _is_checksum_valid \<SHA256SUM\> <FILE_PATH><br>
>   FILE_PATH:  The path to the input file.<br>
>   SHA256SUM:  A string containing file checksum.<br>

#### 3. `_is_gnome` (private)

Check current desktop is gnome

#### 4. `_is_installed` (private)

Check provided command is installed
> Synopsis: _is_installed \<COMMAND\><br>
>   COMMAND:  A string containing command name.<br>

#### 5. `_is_root` (private)

Check current user is root

#### 6. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally
> Synopsis: _pwd<br>

#### 7. `_require` (private)

Install required command
> Synopsis: _require \<COMMAND\> [FROM_PACKAGE_NAME] [PACKAGE_MANAGER]<br>
>   COMMAND:           The command/package to install.<br>
>   FROM_PACKAGE_NAME: (optional) The package name where the command should be found (if different). Defaults to "COMMAND".<br>
>   PACKAGE_MANAGER:   (optional) The package manager required to install the package with. Defaults to "apt".<br>
>   note:              "FROM_PACKAGE_NAME" is required if you need to set "PACKCAGE_MANAGER" parameter.<br>
>                      eg: `_require curl` will install "curl" with "sudo apt install --yes curl".<br>
>                      eg: `_require adb android-tools-adb` will install "android-tools-adb" package.<br>
>                      eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn".<br>

#### 8. `_spin` (private)

Animate a spinner in the terminal for a given amout of time
> Synopsis: _spin [DURATION]<br>
>   DURATION:  Animation duration in miliseconds<br>

#### 9. `_user_exists` (private)

Check provided user exists

### ⚡ Validation

#### 1. `_is_valid` (private)

Checks if variable is valid given regex constraint
> Synopsis: _is_valid \<VALUE\> <PATTERN><br>
>   VALUE:    The string to be compared to regex pattern.<br>
>   PATTERN:  The regex parttern to apply.<br>

#### 2. `_validate` (private)

Find constraints and validates a variable
> Synopsis: _validate \<VARIABLE\><br>
>   VARIABLE: The variable to validate in the followling format : variable_name=value.<br>

### ⚡ kernel

#### 1. `_kernel` (private)

Shoe Kernel

