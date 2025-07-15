TangoMan Shoe
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0
- link:    https://github.com/TangoMan75/shoe


## 📑 Description

Simplify your shell scripting workflow with self-documenting
shell scripts with robust argument validation. Just prefix a
comment with two pound signs (##) on the line above any
function or variable to generate helpful documentation using
the "help" command.

Warning: Functions and variables names should not contain dashes.

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

#### 1. `hello` (public)

Greets a specified recipient a given number of times (the recipient's name is provided with the "--who" option)

##### Synopsis
> hello (public) 

#### 1. `flag_test` (public)

Prints flag status

##### Synopsis
> flag_test (public) 

#### 1. `_private` (private)

Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.

##### Synopsis
> _private (private) 

#### 1. `self_install` (public)

Install script and enable completion

##### Synopsis
> self_install (public) 

#### 1. `self_uninstall` (public)

Uninstall script from system

##### Synopsis
> self_uninstall (public) 

#### 1. `self_update` (public)

Update script from @update

##### Synopsis
> self_update (public) 

#### 1. `generate_doc` (public)

Generate Markdown documentation for current shoe script

##### Synopsis
> generate_doc (public) 

#### 1. `generate_makefile` (public)

Generate Makefile for current shoe script

##### Synopsis
> generate_makefile (public) 

#### 1. `help` (public)

Print this help

##### Synopsis
> help (public) 

#### 1. `_default` (private)

Place here commands you need executed by default (optional)

##### Synopsis
> _default (private) 

#### 1. `_before` (private)

Place here commands you need executed first every time (optional)

##### Synopsis
> _before (private) 

#### 1. `_after` (private)

Place here commands you need executed last every time (optional)

##### Synopsis
> _after (private) 

#### 1. `_adb_connect` (private)

Connect to device with adb via wifi (not recommended when flashing images)

##### Synopsis
> _adb_connect (private) &lt;IP&gt; [PORT]
- `IP`: _(type: "str")_ Device IP address.
- `PORT`: _(type: "int")_ (optional) Destination port. _Defaults to "5555"._

#### 1. `_adb_sideload` (private)

Sideload given full OTA package to connected device

##### Synopsis
> _adb_sideload (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_adb_start_server` (private)

Start local adb server

##### Synopsis
> _adb_start_server (private) 

#### 1. `_fastboot_lock` (private)

Lock bootloader and flashing

##### Synopsis
> _fastboot_lock (private) 

#### 1. `_fastboot_unlock` (private)

Unlock bootloader and flashing

##### Synopsis
> _fastboot_unlock (private) 

#### 1. `_fastboot_wipe` (private)

Wipe userdata on connected device

##### Synopsis
> _fastboot_wipe (private) 

#### 1. `_flash_img` (private)

Flash img file to connected device provided partition

##### Synopsis
> _flash_img (private) &lt;FILE_PATH&gt; &lt;PARTITION&gt; [FORCE]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PARTITION`: _(type: "str")_ The name of the target partition.
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

#### 1. `_get_apk_label` (private)

Get APK label

##### Synopsis
> _get_apk_label (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_get_apk_package_name` (private)

Get APK package_name

##### Synopsis
> _get_apk_package_name (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_get_apk_path` (private)

Get installed APK path on connected device from package name

##### Synopsis
> _get_apk_path (private) &lt;PACKAGE_NAME&gt;
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"

#### 1. `_get_apk_version` (private)

Get APK version

##### Synopsis
> _get_apk_version (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_install_apk` (private)

Install APK on connected device

##### Synopsis
> _install_apk (private) &lt;FILE_PATH&gt; [FORCE]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

#### 1. `_is_apk_installed` (private)

Check if package is installed on connected device

##### Synopsis
> _is_apk_installed (private) &lt;PACKAGE_NAME&gt;
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"

#### 1. `_is_device_connected_with_adb` (private)

Check device is connected with adb

##### Synopsis
> _is_device_connected_with_adb (private) 

#### 1. `_is_device_connected_with_fastboot` (private)

Check device is connected with fastboot

##### Synopsis
> _is_device_connected_with_fastboot (private) 

#### 1. `_list_installed_apks` (private)

List installed packages on connected device

##### Synopsis
> _list_installed_apks (private) 

#### 1. `_pull_apk` (private)

Copy APK from connected device to local folder

##### Synopsis
> _pull_apk (private) &lt;PACKAGE_NAME&gt; &lt;DESTINATION&gt;
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.

#### 1. `_reboot_bootloader` (private)

Reboot connected device to bootloader

##### Synopsis
> _reboot_bootloader (private) 

#### 1. `_reboot_recovery` (private)

Reboot connected device to recovery

##### Synopsis
> _reboot_recovery (private) 

#### 1. `_reboot_system` (private)

Reboot connected device to system

##### Synopsis
> _reboot_system (private) 

#### 1. `_reboot_with_img` (private)

Boot connected device with given image temporarily

##### Synopsis
> _reboot_with_img (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_remove_apk` (private)

Remove APK from connected device

##### Synopsis
> _remove_apk (private) &lt;PACKAGE_NAME&gt; [FORCE]
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

#### 1. `_toggle_active_slot` (private)

Toggle connected device active slot

##### Synopsis
> _toggle_active_slot (private) 

#### 1. `_get_shoedoc_description` (private)

Get shoedoc description

##### Synopsis
> _get_shoedoc_description (private) &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

#### 1. `_get_shoedoc` (private)

Get shoedoc

##### Synopsis
> _get_shoedoc (private) &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

#### 1. `_get_shoedoc_tag` (private)

Return given tag values from shoedoc bloc

##### Synopsis
> _get_shoedoc_tag (private) &lt;TEXT&gt; &lt;TAG_NAME&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.
- `TAG_NAME`: _(type: "str")_ The name of tag to return.

#### 1. `_get_shoedoc_title` (private)

Get shoedoc title

##### Synopsis
> _get_shoedoc_title (private) &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

#### 1. `_get_script_shoedoc` (private)

Get shoedoc bloc at the top the provided shoe script file

##### Synopsis
> _get_script_shoedoc (private) &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

#### 1. `echo_primary` (public)

Print primary text with optional indentation and padding

##### Synopsis
> echo_primary (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_secondary` (public)

Print secondary text with optional indentation and padding

##### Synopsis
> echo_secondary (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_success` (public)

Print success text with optional indentation and padding

##### Synopsis
> echo_success (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_danger` (public)

Print danger text with optional indentation and padding

##### Synopsis
> echo_danger (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_warning` (public)

Print warning text with optional indentation and padding

##### Synopsis
> echo_warning (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_info` (public)

Print info text with optional indentation and padding

##### Synopsis
> echo_info (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_light` (public)

Print light text with optional indentation and padding

##### Synopsis
> echo_light (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_dark` (public)

Print dark text with optional indentation and padding

##### Synopsis
> echo_dark (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `alert_primary` (public)

Print primary alert

##### Synopsis
> alert_primary (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_secondary` (public)

Print secondary alert

##### Synopsis
> alert_secondary (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_success` (public)

Print success alert

##### Synopsis
> alert_success (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_danger` (public)

Print danger alert

##### Synopsis
> alert_danger (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_warning` (public)

Print warning alert

##### Synopsis
> alert_warning (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_info` (public)

Print info alert

##### Synopsis
> alert_info (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_light` (public)

Print light alert

##### Synopsis
> alert_light (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_dark` (public)

Print dark alert

##### Synopsis
> alert_dark (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `_open` (private)

Open with default system handler

##### Synopsis
> _open (private) 

#### 1. `_sed_i` (private)

Return sed -i system flavour

##### Synopsis
> _sed_i (private) 

#### 1. `_docker_compose_build` (private)

Build container stack with docker compose

##### Synopsis
> _docker_compose_build (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the compose.yaml file.

#### 1. `_docker_compose_start` (private)

Build and start container stack with docker compose

##### Synopsis
> _docker_compose_start (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the compose.yaml file.

#### 1. `_docker_compose_stop` (private)

Stop container stack with docker compose

##### Synopsis
> _docker_compose_stop (private) 

#### 1. `_docker_exec` (private)

Execute command in the given docker container

##### Synopsis
> _docker_exec (private) &lt;CONTAINER_NAME&gt; &lt;COMMAND&gt; [USER]
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.
- `COMMAND`: _(type: "str")_ The command to execute.
- `USER`: _(type: "str")_ (optional) The user name.

#### 1. `_docker_kill_all` (private)

Kill all running containers with docker

##### Synopsis
> _docker_kill_all (private) 

#### 1. `_docker_rm` (private)

Remove given docker container

##### Synopsis
> _docker_rm (private) &lt;CONTAINER_NAME&gt;
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.

#### 1. `_docker_run_atmoz_sftp` (private)

Run local atmoz_sftp server

##### Synopsis
> _docker_run_atmoz_sftp (private) &lt;USERNAME&gt; &lt;PASSWORD&gt; [NETWORK_MODE] [FOLDER_PATH]
- `USERNAME`: _(type: "str")_ The name of the container to run.
- `PASSWORD`: _(type: "str")_ The password for the sftp server access.
- `NETWORK_MODE`: _(type: "str")_ (optional) The user name.
- `FOLDER_PATH`: _(type: "folder")_ (optional) The path to the volume folder.

#### 1. `_docker_run` (private)

Spawn a new container with given image, name, command and volume

##### Synopsis
> _docker_run (private) &lt;IMAGE&gt; &lt;NAME&gt; &lt;COMMAND&gt; [FOLDER_PATH]
- `IMAGE`: _(type: "str")_ The name of the container image to run.
- `NAME`: _(type: "str")_ Assign a name to the container.
- `COMMAND`: _(type: "str")_ The command to run inside provided container.
- `FOLDER_PATH`: _(type: "folder")_ (optional) The path to the volume folder.

#### 1. `_docker_run_whoami` (private)

Run local whoami server

##### Synopsis
> _docker_run_whoami (private) 

#### 1. `_docker_status` (private)

Print docker status

##### Synopsis
> _docker_status (private) 

#### 1. `_find_container_name` (private)

Find container name from string

##### Synopsis
> _find_container_name (private) &lt;STRING&gt;
- `STRING`: _(type: "str")_ The string to find among running containers.

#### 1. `_get_container_id` (private)

Get container id from name

##### Synopsis
> _get_container_id (private) &lt;CONTAINER_NAME&gt; [TRUNCATE]
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.
- `TRUNCATE`: _(type: "bool")_ (optional) Truncate id to 12 characters long. _Defaults to "true"._

#### 1. `_get_container_ip` (private)

Get running container ip

##### Synopsis
> _get_container_ip (private) &lt;CONTAINER_NAME|CONTAINER_ID&gt;
- `CONTAINER_NAME|CONTAINER_ID`: _(type: "str")_ The name or the id of the docker container.

#### 1. `_get_container_name` (private)

Get container name from id

##### Synopsis
> _get_container_name (private) &lt;CONTAINER_ID&gt;
- `CONTAINER_ID`: _(type: "str")_ The container id.

#### 1. `_get_docker_compose` (private)

Return docker compose command

##### Synopsis
> _get_docker_compose (private) 

#### 1. `_is_container_running` (private)

Checks if given container is running

##### Synopsis
> _is_container_running (private) &lt;CONTAINER_NAME|CONTAINER_ID&gt;
- `CONTAINER_NAME|CONTAINER_ID`: _(type: "str")_ The name or the id of the docker container.

#### 1. `_wait_for_postgres` (private)

Wait for postgresql container to start with docker

##### Synopsis
> _wait_for_postgres (private) &lt;CONTAINER_NAME&gt; [USERNAME]
- `CONTAINER_NAME`: _(type: "str")_ The name of the docker container.
- `USERNAME`: _(type: "str")_ (optional) The psql username. _Defaults to ""._

#### 1. `_wait_for_rabbit` (private)

Wait for rabbitmq container to start with docker

##### Synopsis
> _wait_for_rabbit (private) &lt;CONTAINER_NAME&gt;
- `CONTAINER_NAME`: _(type: "str")_ The name of the docker container.

#### 1. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script

##### Synopsis
> _generate_doc (private) &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", documents private constants, options, flags, and commands as well. _Defaults to "false"._

#### 1. `_get_file_extension` (private)

Get file extension

##### Synopsis
> _get_file_extension (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_move` (private)

Move file to destination folder (creates folder when missing)

##### Synopsis
> _move (private) &lt;FILE_PATH&gt; &lt;DESTINATION_FOLDER&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `DESTINATION_FOLDER`: _(type: "folder")_ The path to the destination folder.

#### 1. `_git_hooks` (private)

Update .git/hooks folder

##### Synopsis
> _git_hooks (private) &lt;SOURCE&gt;
- `SOURCE`: _(type: "folder")_ The source directory.

#### 1. `_initialise_submodules` (private)

Initialise git submodules

##### Synopsis
> _initialise_submodules (private) 

#### 1. `_help` (private)

Print help for provider shoe script

##### Synopsis
> _help (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_print_commands` (private)

List commands of the provided shoe script (used by "help" command)

##### Synopsis
> _print_commands (private) &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

#### 1. `_print_constants` (private)

List constants of the provided shoe script (used by "help" command)

##### Synopsis
> _print_constants (private) &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

#### 1. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)

##### Synopsis
> _print_description (private) &lt;DESCRIPTION&gt;
- `DESCRIPTION`: _(type: "str")_ A string containing script description.

#### 1. `_print_flags` (private)

List flags of the provided shoe script (used by "help" command)

##### Synopsis
> _print_flags (private) &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

#### 1. `_print_infos` (private)

Print infos of the provided shoe script (used by "help" command)

##### Synopsis
> _print_infos (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_print_options` (private)

List options of the provided shoe script (used by "help" command)

##### Synopsis
> _print_options (private) &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

#### 1. `_print_usage` (private)

Print usage of the provided shoe script (used by "help" command)

##### Synopsis
> _print_usage (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_copy_install` (private)

Install script via copy

##### Synopsis
> _copy_install (private) &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file

##### Synopsis
> _generate_autocomplete (private) &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file

##### Synopsis
> _generate_global_autocomplete (private) &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_get_comspec` (private)

Generate comspec string for the provided file

##### Synopsis
> _get_comspec (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_install` (private)

Install script and enable completion

##### Synopsis
> _install (private) &lt;FILE_PATH&gt; [ALIAS] [GLOBAL]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

#### 1. `_remove_completion_autoload` (private)

Remove completion script autoload

##### Synopsis
> _remove_completion_autoload (private) &lt;SHELL_CONFIG_FILE&gt; [ALIAS]
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file

##### Synopsis
> _set_completion_autoload (private) &lt;SHELL_CONFIG_FILE&gt; &lt;SCRIPT_FILE_PATH&gt; [ALIAS]
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `SCRIPT_FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_symlink_install` (private)

Install script via symlink

##### Synopsis
> _symlink_install (private) &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_uninstall` (private)

Uninstall script from system

##### Synopsis
> _uninstall (private) &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_update` (private)

Updates given script from the provided URL

##### Synopsis
> _update (private) &lt;FILE_PATH&gt; &lt;URL&gt; [ALIAS] [GLOBAL]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `URL`: _(type: "str")_ The URL of the script to download and install.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

#### 1. `_generate_makefile` (private)

Generate Makefile for provided shoe script

##### Synopsis
> _generate_makefile (private) &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

#### 1. `_open_in_default_browser` (private)

Open in default browser

##### Synopsis
> _open_in_default_browser (private) [IP] [PORT]
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Defaults to "8080"._

#### 1. `_php_serve` (private)

Serve given local directory with PHP

##### Synopsis
> _php_serve (private) &lt;DOCROOT&gt; [IP] [PORT]
- `DOCROOT`: _(type: "folder")_ The path to the root directory.
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Defaults to "8080"._

#### 1. `_py_serve` (private)

Serve given local directory with Python 3

##### Synopsis
> _py_serve (private) &lt;DOCROOT&gt; [IP] [PORT]
- `DOCROOT`: _(type: "folder")_ The path to the root directory.
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Defaults to "8080"._

#### 1. `_remove_host` (private)

Remove hostname from /etc/hosts

##### Synopsis
> _remove_host (private) &lt;HOSTNAME&gt;
- `HOSTNAME`: _(type: "str")_ The hostame to unset locally.

#### 1. `_set_host` (private)

Set new host in /etc/hosts

##### Synopsis
> _set_host (private) &lt;HOSTNAME&gt;
- `HOSTNAME`: _(type: "str")_ The hostame to set locally.

#### 1. `_select` (private)

Present user with a list of choices and prompt them to select one

##### Synopsis
> _select (private) &lt;CHOICES&gt;
- `CHOICES`: _(type: "str")_ Array containing choices.

#### 1. `_yes_no` (private)

Promt user for yes or no

##### Synopsis
> _yes_no (private) [QUESTION]
- `QUESTION`: _(type: "str")_ (optional) A string containing the question. _Defaults to "Confirm ?"._

#### 1. `_get_constants` (private)

List constants from provided shoe script

##### Synopsis
> _get_constants (private) &lt;SCRIPT_PATH&gt; [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private constants as well. _Defaults to "false"._

#### 1. `_get_constraint` (private)

Get constaint for given variable from provided shoe script

##### Synopsis
> _get_constraint (private) &lt;SCRIPT_PATH&gt; &lt;VARIABLE_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `VARIABLE_NAME`: _(type: "str")_ The variable to validate.

#### 1. `_get_flags` (private)

List flags from provided shoe script

##### Synopsis
> _get_flags (private) &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

#### 1. `_get_function` (private)

Get function by name

##### Synopsis
> _get_function (private) &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

#### 1. `_get_function_annotation` (private)

Get function annotation by name

##### Synopsis
> _get_function_annotation (private) &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

#### 1. `_get_functions_names` (private)

List functions names from provided shoe script

##### Synopsis
> _get_functions_names (private) &lt;SCRIPT_PATH&gt; [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private functions as well. _Defaults to "false"._

#### 1. `_get_options` (private)

List options from provided shoe script

##### Synopsis
> _get_options (private) &lt;SCRIPT_PATH&gt; [GET_PRIVATE_ONLY]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE_ONLY`: _(type: "bool")_ (optional) If set to "true", retrieves private options only. _Defaults to "false"._

#### 1. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script

##### Synopsis
> _get_padding (private) &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

#### 1. `_get_parameter` (private)

Get value for given parameter from provided ".env" or ".sh" file

##### Synopsis
> _get_parameter (private) &lt;FILE_PATH&gt; &lt;KEY&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.

#### 1. `_parse_annotation` (private)

Return function annotation as json

##### Synopsis
> _parse_annotation (private) &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

#### 1. `_set_parameter` (private)

Set value for given parameter into provided file ".env" or ".sh" file

##### Synopsis
> _set_parameter (private) &lt;FILE_PATH&gt; &lt;KEY&gt; &lt;VALUE&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.
- `VALUE`: _(type: "str")_ The value to be set to provided file.

#### 1. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"

##### Synopsis
> _collapse_blank_lines (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_generate_key` (private)

Generate random 32 bit string

##### Synopsis
> _generate_key (private) 

#### 1. `_check_installed` (private)

Print error message if provided command is missing

##### Synopsis
> _check_installed (private) &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

#### 1. `_get_package_manager` (private)

Print default package manager

##### Synopsis
> _get_package_manager (private) 

#### 1. `_get_package_name` (private)

Find package name for given command

##### Synopsis
> _get_package_name (private) &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

#### 1. `_is_checksum_valid` (private)

Validate a file checksum

##### Synopsis
> _is_checksum_valid (private) &lt;FILE_PATH&gt; &lt;SHA256SUM&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `SHA256SUM`: _(type: "str")_ A string containing file checksum.

#### 1. `_is_gnome` (private)

Check current desktop is gnome

##### Synopsis
> _is_gnome (private) 

#### 1. `_is_installed` (private)

Check provided command is installed

##### Synopsis
> _is_installed (private) &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

#### 1. `_is_root` (private)

Check current user is root

##### Synopsis
> _is_root (private) 

#### 1. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally

##### Synopsis
> _pwd (private) 

#### 1. `_remove` (private)

Remove given package from system

##### Synopsis
> _remove (private) &lt;PACKAGE&gt; [PACKAGE_MANAGER]
- `PACKAGE`: _(type: "str")_ The command/package to remove.
- `PACKAGE_MANAGER`: _(type: "str")_ (optional) The package manager required to remove the package with. _Defaults to "apt"._

#### 1. `_require` (private)

Install required package globally

##### Synopsis
> _require (private) &lt;PACKAGE&gt; [PACKAGE_MANAGER]
- `PACKAGE`: _(type: "str")_ The command/package to remove.
- `PACKAGE_MANAGER`: _(type: "str")_ (optional) The package manager required to remove the package with. _Defaults to "apt"._

#### 1. `_spin` (private)

Animate a spinner in the terminal for a given amout of time

##### Synopsis
> _spin (private) [DURATION]
- `DURATION`: _(type: "int")_ (optional) Animation duration in miliseconds. _Defaults to "0"._

#### 1. `_user_exists` (private)

Check provided user exists

##### Synopsis
> _user_exists (private) &lt;USERNAME&gt;
- `USERNAME`: _(type: "str")_ The username to check.

#### 1. `_is_valid` (private)

Checks if variable is valid given regex constraint

##### Synopsis
> _is_valid (private) &lt;VALUE&gt; &lt;PATTERN&gt;
- `VALUE`: _(type: "str")_ The string to be compared to regex pattern.
- `PATTERN`: _(type: "str")_ The regex parttern to apply.

#### 1. `_validate` (private)

Find constraints and validates a variable

##### Synopsis
> _validate (private) &lt;VARIABLE&gt;
- `VARIABLE`: _(type: "str")_ The variable to validate in the followling format : variable_name=value.

#### 1. `_kernel` (private)

Shoe Kernel

##### Synopsis
> _kernel (private) 

