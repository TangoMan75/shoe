TangoMan Shoe
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 0.1.0
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
  - 🚩 Default: _"I'm a global variable"_

## 🚩 Flags

1. **`--flag`**
> Example Flag (any variable set to "false" will convert to a flag at runtime)

2. **`--global`**
> Install script globally

## ⚙️ Options

1. **`--who`**
> Greeting recipient name 
  - 🧩 Constraint: `/^[a-zA-Z-]+$/`
  - 🚩 Default: _"World"_

2. **`--count`**
> How many times to say hello 
  - 🧩 Constraint: `/[1-9]/`
  - 🚩 Default: _1_

## 🤖 Commands

#### ⌨️ 1. `hello` (public)

Greets a specified recipient a given number of times (the recipient's name is provided with the "--who" option)

> Synopsis:
> hello [who]
- `who`: _(type: "str")_ (optional) The recipient's name.

#### ⌨️ 2. `flag_test` (public)

Prints flag status

> Synopsis:
> flag_test

#### ⌨️ 3. `_private` (private)

Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.

> Synopsis:
> _private

### ⚡ INSTALL

#### ⌨️ 1. `self_install` (public)

Install script and enable completion

> Synopsis:
> self_install

- 🔗 Depends: `_install`

#### ⌨️ 2. `self_uninstall` (public)

Uninstall script from system

> Synopsis:
> self_uninstall

- 🔗 Depends: `_uninstall`

#### ⌨️ 3. `self_update` (public)

Update script from @update

> Synopsis:
> self_update

- 🔗 Depends: `_get_annotation_tags`, `_get_script_shoedoc`, `_update`

### ⚡ DOCUMENTATION

#### ⌨️ 1. `generate_doc` (public)

Generate Markdown documentation for current shoe script

> Synopsis:
> generate_doc

- 🔗 Depends: `_generate_doc`

### ⚡ MAKE

#### ⌨️ 1. `generate_makefile` (public)

Generate Makefile for current shoe script

> Synopsis:
> generate_makefile

- 🔗 Depends: `_generate_makefile`

### ⚡ HELP

#### ⌨️ 1. `help` (public)

Print this help

> Synopsis:
> help

- 🔗 Depends: `_help`

### ⚡ HOOKS

#### ⌨️ 1. `_default` (private)

Place here commands you need executed by default (optional)

> Synopsis:
> _default

#### ⌨️ 2. `_before` (private)

Place here commands you need executed first every time (optional)

> Synopsis:
> _before

#### ⌨️ 3. `_after` (private)

Place here commands you need executed last every time (optional)

> Synopsis:
> _after

### ⚡ ANDROID

#### ⌨️ 1. `_adb_connect` (private)

Connect to device with adb via wifi (not recommended when flashing images)

> Synopsis:
> _adb_connect &lt;IP&gt; [PORT]
- `IP`: _(type: "str")_ Device IP address.
- `PORT`: _(type: "int")_ (optional) Destination port. _Defaults to "5555"._

- ⚠️ Requires: `adb`
- 🔗 Depends: `_check_installed`, `echo_danger`, `echo_info`

#### ⌨️ 2. `_adb_sideload` (private)

Sideload given full OTA package to connected device

> Synopsis:
> _adb_sideload &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `adb`
- 🔗 Depends: `_check_installed`, `echo_danger`, `echo_info`

#### ⌨️ 3. `_adb_start_server` (private)

Start local adb server

> Synopsis:
> _adb_start_server

- ⚠️ Requires: `adb`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 4. `_fastboot_lock` (private)

Lock bootloader and flashing

> Synopsis:
> _fastboot_lock

- ⚠️ Requires: `fastboot`
- 🔗 Depends: `_is_device_connected_with_fastboot`, `echo_danger`, `echo_info`

#### ⌨️ 5. `_fastboot_unlock` (private)

Unlock bootloader and flashing

> Synopsis:
> _fastboot_unlock

- ⚠️ Requires: `fastboot`
- 🔗 Depends: `_is_device_connected_with_fastboot`, `echo_danger`, `echo_info`

#### ⌨️ 6. `_fastboot_wipe` (private)

Wipe userdata on connected device

> Synopsis:
> _fastboot_wipe

- ⚠️ Requires: `fastboot`
- 🔗 Depends: `_is_device_connected_with_fastboot`, `echo_danger`, `echo_info`

#### ⌨️ 7. `_flash_img` (private)

Flash img file to connected device provided partition

> Synopsis:
> _flash_img &lt;FILE_PATH&gt; &lt;PARTITION&gt; [FORCE]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PARTITION`: _(type: "str")_ The name of the target partition.
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

- ⚠️ Requires: `fastboot`
- 🔗 Depends: `_is_device_connected_with_fastboot`, `echo_danger`, `echo_info`

#### ⌨️ 8. `_get_apk_label` (private)

Get APK label

> Synopsis:
> _get_apk_label &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `aapt`
- 🔗 Depends: `_check_installed`, `echo_danger`

#### ⌨️ 9. `_get_apk_package_name` (private)

Get APK package_name

> Synopsis:
> _get_apk_package_name &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `aapt`
- 🔗 Depends: `_check_installed`, `echo_danger`

#### ⌨️ 10. `_get_apk_path` (private)

Get installed APK path on connected device from package name

> Synopsis:
> _get_apk_path &lt;PACKAGE_NAME&gt;
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"

- ⚠️ Requires: `adb`
- 🔗 Depends: `_is_device_connected_with_adb`, `echo_danger`

#### ⌨️ 11. `_get_apk_version` (private)

Get APK version

> Synopsis:
> _get_apk_version &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `aapt`
- 🔗 Depends: `_check_installed`, `echo_danger`

#### ⌨️ 12. `_install_apk` (private)

Install APK on connected device

> Synopsis:
> _install_apk &lt;FILE_PATH&gt; [FORCE]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

- ⚠️ Requires: `adb`
- 🔗 Depends: `_is_device_connected_with_adb`, `echo_danger`, `echo_info`

#### ⌨️ 13. `_is_apk_installed` (private)

Check if package is installed on connected device

> Synopsis:
> _is_apk_installed &lt;PACKAGE_NAME&gt;
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"

- ⚠️ Requires: `adb`
- 🔗 Depends: `_is_device_connected_with_adb`, `echo_danger`

#### ⌨️ 14. `_is_device_connected_with_adb` (private)

Check device is connected with adb

> Synopsis:
> _is_device_connected_with_adb

- ⚠️ Requires: `adb`
- 🔗 Depends: `_check_installed`

#### ⌨️ 15. `_is_device_connected_with_fastboot` (private)

Check device is connected with fastboot

> Synopsis:
> _is_device_connected_with_fastboot

- ⚠️ Requires: `fastboot`
- 🔗 Depends: `_check_installed`

#### ⌨️ 16. `_list_installed_apks` (private)

List installed packages on connected device

> Synopsis:
> _list_installed_apks

- ⚠️ Requires: `adb`
- 🔗 Depends: `_is_device_connected_with_adb`, `echo_danger`

#### ⌨️ 17. `_pull_apk` (private)

Copy APK from connected device to local folder

> Synopsis:
> _pull_apk &lt;PACKAGE_NAME&gt; &lt;DESTINATION&gt;
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.

- ⚠️ Requires: `adb`
- 🔗 Depends: `_is_device_connected_with_adb`, `echo_danger`, `echo_info`

#### ⌨️ 18. `_reboot_bootloader` (private)

Reboot connected device to bootloader

> Synopsis:
> _reboot_bootloader

- ⚠️ Requires: `adb`, `fastboot`
- 🔗 Depends: `_is_device_connected_with_adb`, `_is_device_connected_with_fastboot`, `echo_danger`, `echo_info`

#### ⌨️ 19. `_reboot_recovery` (private)

Reboot connected device to recovery

> Synopsis:
> _reboot_recovery

- ⚠️ Requires: `adb`, `fastboot`
- 🔗 Depends: `_is_device_connected_with_adb`, `_is_device_connected_with_fastboot`, `echo_danger`, `echo_info`

#### ⌨️ 20. `_reboot_system` (private)

Reboot connected device to system

> Synopsis:
> _reboot_system

- ⚠️ Requires: `adb`, `fastboot`
- 🔗 Depends: `_is_device_connected_with_adb`, `_is_device_connected_with_fastboot`, `echo_danger`, `echo_info`

#### ⌨️ 21. `_reboot_with_img` (private)

Boot connected device with given image temporarily

> Synopsis:
> _reboot_with_img &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `fastboot`
- 🔗 Depends: `_is_device_connected_with_fastboot`, `echo_danger`, `echo_info`

#### ⌨️ 22. `_remove_apk` (private)

Remove APK from connected device

> Synopsis:
> _remove_apk &lt;PACKAGE_NAME&gt; [FORCE]
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

- ⚠️ Requires: `adb`
- 🔗 Depends: `_is_device_connected_with_adb`, `echo_danger`, `echo_info`

#### ⌨️ 23. `_toggle_active_slot` (private)

Toggle connected device active slot

> Synopsis:
> _toggle_active_slot

- ⚠️ Requires: `fastboot`
- 🔗 Depends: `_is_device_connected_with_fastboot`, `echo_danger`, `echo_info`

### ⚡ SHOEDOC

#### ⌨️ 1. `_get_shoedoc_description` (private)

Get shoedoc description

> Synopsis:
> _get_shoedoc_description &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 2. `_get_shoedoc` (private)

Get shoedoc

> Synopsis:
> _get_shoedoc &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 3. `_get_shoedoc_tag` (private)

Return given tag values from shoedoc bloc

> Synopsis:
> _get_shoedoc_tag &lt;TEXT&gt; &lt;TAG_NAME&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.
- `TAG_NAME`: _(type: "str")_ The name of tag to return.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 4. `_get_shoedoc_title` (private)

Get shoedoc title

> Synopsis:
> _get_shoedoc_title &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 5. `_get_script_shoedoc` (private)

Get shoedoc bloc at the top the provided shoe script file

> Synopsis:
> _get_script_shoedoc &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

### ⚡ COLORS

#### ⌨️ 1. `echo_primary` (public)

Print primary text with optional indentation and padding

> Synopsis:
> echo_primary &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 2. `echo_secondary` (public)

Print secondary text with optional indentation and padding

> Synopsis:
> echo_secondary &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 3. `echo_success` (public)

Print success text with optional indentation and padding

> Synopsis:
> echo_success &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 4. `echo_danger` (public)

Print danger text with optional indentation and padding

> Synopsis:
> echo_danger &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 5. `echo_warning` (public)

Print warning text with optional indentation and padding

> Synopsis:
> echo_warning &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 6. `echo_info` (public)

Print info text with optional indentation and padding

> Synopsis:
> echo_info &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 7. `echo_light` (public)

Print light text with optional indentation and padding

> Synopsis:
> echo_light &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 8. `echo_dark` (public)

Print dark text with optional indentation and padding

> Synopsis:
> echo_dark &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 9. `alert_primary` (public)

Print primary alert

> Synopsis:
> alert_primary &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 10. `alert_secondary` (public)

Print secondary alert

> Synopsis:
> alert_secondary &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 11. `alert_success` (public)

Print success alert

> Synopsis:
> alert_success &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 12. `alert_danger` (public)

Print danger alert

> Synopsis:
> alert_danger &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 13. `alert_warning` (public)

Print warning alert

> Synopsis:
> alert_warning &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 14. `alert_info` (public)

Print info alert

> Synopsis:
> alert_info &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 15. `alert_light` (public)

Print light alert

> Synopsis:
> alert_light &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 16. `alert_dark` (public)

Print dark alert

> Synopsis:
> alert_dark &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

### ⚡ COMPATIBILITY

#### ⌨️ 1. `_open` (private)

Open with default system handler

> Synopsis:
> _open

- ⚠️ Requires: `uname`

#### ⌨️ 2. `_sed_i` (private)

Return sed -i system flavour

> Synopsis:
> _sed_i

- ⚠️ Requires: `command`, `sed`, `uname`

### ⚡ DOCKER

#### ⌨️ 1. `_docker_compose_build` (private)

Build container stack with docker compose

> Synopsis:
> _docker_compose_build [FILE_PATH]
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.

- 🔗 Depends: `_get_docker_compose`, `echo_danger`, `echo_info`

#### ⌨️ 2. `_docker_compose_start` (private)

Build and start container stack with docker compose

> Synopsis:
> _docker_compose_start [FILE_PATH]
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.

- 🔗 Depends: `_get_docker_compose`, `echo_danger`, `echo_info`

#### ⌨️ 3. `_docker_compose_stop` (private)

Stop container stack with docker compose

> Synopsis:
> _docker_compose_stop

- 🔗 Depends: `_get_docker_compose`, `echo_info`

#### ⌨️ 4. `_docker_exec` (private)

Execute command in the given docker container

> Synopsis:
> _docker_exec &lt;CONTAINER_NAME&gt; &lt;COMMAND&gt; [USER]
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.
- `COMMAND`: _(type: "str")_ The command to execute.
- `USER`: _(type: "str")_ (optional) The user name.

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_danger`, `echo_info`

#### ⌨️ 5. `_docker_kill_all` (private)

Kill all running containers with docker

> Synopsis:
> _docker_kill_all

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 6. `_docker_rm` (private)

Remove given docker container

> Synopsis:
> _docker_rm &lt;CONTAINER_NAME&gt;
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_danger`, `echo_info`

#### ⌨️ 7. `_docker_run_atmoz_sftp` (private)

Run local atmoz_sftp server

> Synopsis:
> _docker_run_atmoz_sftp &lt;USERNAME&gt; &lt;PASSWORD&gt; [NETWORK_MODE] [FOLDER_PATH]
- `USERNAME`: _(type: "str")_ The name of the container to run.
- `PASSWORD`: _(type: "str")_ The password for the sftp server access.
- `NETWORK_MODE`: _(type: "str")_ (optional) The user name.
- `FOLDER_PATH`: _(type: "folder")_ (optional) The path to the volume folder.

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_danger`, `echo_info`

#### ⌨️ 8. `_docker_run` (private)

Spawn a new container with given image, name, command and volume

> Synopsis:
> _docker_run &lt;IMAGE&gt; &lt;NAME&gt; &lt;COMMAND&gt; [FOLDER_PATH]
- `IMAGE`: _(type: "str")_ The name of the container image to run.
- `NAME`: _(type: "str")_ Assign a name to the container.
- `COMMAND`: _(type: "str")_ The command to run inside provided container.
- `FOLDER_PATH`: _(type: "folder")_ (optional) The path to the volume folder.

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_danger`, `echo_info`

#### ⌨️ 9. `_docker_run_whoami` (private)

Run local whoami server

> Synopsis:
> _docker_run_whoami

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 10. `_docker_status` (private)

Print docker status

> Synopsis:
> _docker_status

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 11. `_find_container_name` (private)

Find container name from string

> Synopsis:
> _find_container_name &lt;STRING&gt;
- `STRING`: _(type: "str")_ The string to find among running containers.

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_danger`

#### ⌨️ 12. `_get_container_id` (private)

Get container id from name

> Synopsis:
> _get_container_id &lt;CONTAINER_NAME&gt; [TRUNCATE]
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.
- `TRUNCATE`: _(type: "bool")_ (optional) Truncate id to 12 characters long. _Defaults to "true"._

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_danger`

#### ⌨️ 13. `_get_container_ip` (private)

Get running container ip

> Synopsis:
> _get_container_ip &lt;CONTAINER_NAME|CONTAINER_ID&gt;
- `CONTAINER_NAME|CONTAINER_ID`: _(type: "str")_ The name or the id of the docker container.

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_danger`

#### ⌨️ 14. `_get_container_name` (private)

Get container name from id

> Synopsis:
> _get_container_name &lt;CONTAINER_ID&gt;
- `CONTAINER_ID`: _(type: "str")_ The container id.

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_danger`

#### ⌨️ 15. `_get_docker_compose` (private)

Return docker compose command

> Synopsis:
> _get_docker_compose

- ⚠️ Requires: `command`, `docker`
- 🔗 Depends: `echo_danger`

#### ⌨️ 16. `_is_container_running` (private)

Checks if given container is running

> Synopsis:
> _is_container_running &lt;CONTAINER_NAME|CONTAINER_ID&gt;
- `CONTAINER_NAME|CONTAINER_ID`: _(type: "str")_ The name or the id of the docker container.

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_danger`

#### ⌨️ 17. `_wait_for_postgres` (private)

Wait for postgresql container to start with docker

> Synopsis:
> _wait_for_postgres &lt;CONTAINER_NAME&gt; [USERNAME]
- `CONTAINER_NAME`: _(type: "str")_ The name of the docker container.
- `USERNAME`: _(type: "str")_ (optional) The psql username. _Defaults to ""._

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `_spin`, `echo_danger`, `echo_success`, `echo_warning`

#### ⌨️ 18. `_wait_for_rabbit` (private)

Wait for rabbitmq container to start with docker

> Synopsis:
> _wait_for_rabbit &lt;CONTAINER_NAME&gt;
- `CONTAINER_NAME`: _(type: "str")_ The name of the docker container.

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `_spin`, `echo_danger`, `echo_success`, `echo_warning`

### ⚡ DOCUMENTATION

#### ⌨️ 1. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script

> Synopsis:
> _generate_doc &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", documents private constants, options, flags, and commands as well. _Defaults to "false"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `_get_script_shoedoc`, `_get_shoedoc_description`, `_get_shoedoc_tag`, `_get_shoedoc_title`, `_print_synopsis`, `alert_primary`, `echo_danger`, `echo_success`

### ⚡ FILES

#### ⌨️ 1. `_get_file_extension` (private)

Get file extension

> Synopsis:
> _get_file_extension &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- 🔗 Depends: `echo_danger`

#### ⌨️ 2. `_move` (private)

Move file to destination folder (creates folder when missing)

> Synopsis:
> _move &lt;FILE_PATH&gt; &lt;DESTINATION_FOLDER&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `DESTINATION_FOLDER`: _(type: "folder")_ The path to the destination folder.

- 🔗 Depends: `echo_danger`, `echo_info`

### ⚡ GIT

#### ⌨️ 1. `_git_hooks` (private)

Update .git/hooks folder

> Synopsis:
> _git_hooks &lt;SOURCE&gt;
- `SOURCE`: _(type: "folder")_ The source directory.

- ⚠️ Requires: `git`
- 🔗 Depends: `echo_danger`, `echo_info`

#### ⌨️ 2. `_initialise_submodules` (private)

Initialise git submodules

> Synopsis:
> _initialise_submodules

- ⚠️ Requires: `git`
- 🔗 Depends: `echo_danger`, `echo_info`

### ⚡ HELP

#### ⌨️ 1. `_help` (private)

Print help for provider shoe script

> Synopsis:
> _help &lt;FILE_PATH&gt; [FUNCTION_NAME]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `FUNCTION_NAME`: _(type: "str")_ (optional) The function name to get help for.

- 🔗 Depends: `_get_constants`, `_get_flags`, `_get_function_annotation`, `_get_options`, `_get_padding`, `_get_script_shoedoc`, `_get_shoedoc_description`, `_get_shoedoc_title`, `_print_commands`, `_print_constants`, `_print_description`, `_print_flags`, `_print_infos`, `_print_options`, `_print_synopsis`, `_print_usage`, `alert_primary`, `echo_danger`

#### ⌨️ 2. `_print_commands` (private)

List commands of the provided shoe script (used by "help" command)

> Synopsis:
> _print_commands &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`, `echo_warning`

#### ⌨️ 3. `_print_constants` (private)

List constants of the provided shoe script (used by "help" command)

> Synopsis:
> _print_constants &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`, `echo_warning`

#### ⌨️ 4. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)

> Synopsis:
> _print_description &lt;DESCRIPTION&gt;
- `DESCRIPTION`: _(type: "str")_ A string containing script description.

- 🔗 Depends: `echo_primary`, `echo_warning`

#### ⌨️ 5. `_print_flags` (private)

List flags of the provided shoe script (used by "help" command)

> Synopsis:
> _print_flags &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`, `echo_warning`

#### ⌨️ 6. `_print_infos` (private)

Print infos of the provided shoe script (used by "help" command)

> Synopsis:
> _print_infos &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- 🔗 Depends: `_get_script_shoedoc`, `_get_shoedoc_tag`, `echo_danger`, `echo_primary`, `echo_success`, `echo_warning`

#### ⌨️ 7. `_print_options` (private)

List options of the provided shoe script (used by "help" command)

> Synopsis:
> _print_options &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`, `echo_warning`

#### ⌨️ 8. `_print_usage` (private)

Print usage of the provided shoe script (used by "help" command)

> Synopsis:
> _print_usage &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`, `echo_info`, `echo_success`, `echo_warning`

### ⚡ INSTALL

#### ⌨️ 1. `_copy_install` (private)

Install script via copy

> Synopsis:
> _copy_install &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `echo_danger`, `echo_info`

#### ⌨️ 2. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file

> Synopsis:
> _generate_autocomplete &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `_get_comspec`, `echo_danger`, `echo_info`

#### ⌨️ 3. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file

> Synopsis:
> _generate_global_autocomplete &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `_get_comspec`, `echo_danger`, `echo_info`

#### ⌨️ 4. `_get_comspec` (private)

Generate comspec string for the provided file

> Synopsis:
> _get_comspec &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 5. `_install` (private)

Install script and enable completion

> Synopsis:
> _install &lt;FILE_PATH&gt; [ALIAS] [GLOBAL]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

- 🔗 Depends: `_copy_install`, `_generate_autocomplete`, `_generate_global_autocomplete`, `_is_installed`, `_set_completion_autoload`, `_symlink_install`, `echo_danger`

#### ⌨️ 6. `_remove_completion_autoload` (private)

Remove completion script autoload

> Synopsis:
> _remove_completion_autoload &lt;SHELL_CONFIG_FILE&gt; [ALIAS]
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `_sed_i`, `echo_danger`, `echo_info`

#### ⌨️ 7. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file

> Synopsis:
> _set_completion_autoload &lt;SHELL_CONFIG_FILE&gt; &lt;SCRIPT_FILE_PATH&gt; [ALIAS]
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `SCRIPT_FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `_collapse_blank_lines`, `_sed_i`, `echo_danger`, `echo_info`

#### ⌨️ 8. `_symlink_install` (private)

Install script via symlink

> Synopsis:
> _symlink_install &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `echo_danger`, `echo_info`

#### ⌨️ 9. `_uninstall` (private)

Uninstall script from system

> Synopsis:
> _uninstall &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `_remove_completion_autoload`, `echo_danger`, `echo_info`

#### ⌨️ 10. `_update` (private)

Updates given script from the provided URL

> Synopsis:
> _update &lt;FILE_PATH&gt; &lt;URL&gt; [ALIAS] [GLOBAL]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `URL`: _(type: "str")_ The URL of the script to download and install.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

- ⚠️ Requires: `curl`, `wget`
- 🔗 Depends: `_copy_install`, `_generate_autocomplete`, `_generate_global_autocomplete`, `_install`, `_is_installed`, `_set_completion_autoload`, `_symlink_install`, `_uninstall`, `echo_danger`

### ⚡ MAKE

#### ⌨️ 1. `_generate_makefile` (private)

Generate Makefile for provided shoe script

> Synopsis:
> _generate_makefile &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

- ⚠️ Requires: `awk`
- 🔗 Depends: `_get_script_shoedoc`, `_get_shoedoc_description`, `_get_shoedoc_tag`, `_get_shoedoc_title`, `alert_primary`, `echo_danger`, `echo_success`

### ⚡ NETWORK

#### ⌨️ 1. `_open_in_default_browser` (private)

Open in default browser

> Synopsis:
> _open_in_default_browser [IP] [PORT] [SCHEME]
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Defaults to "8080"._
- `SCHEME`: _(type: "str")_ (optional) scheme - e.g. http. _Defaults to "http"._

- 🔗 Depends: `_open`, `echo_danger`, `echo_info`

#### ⌨️ 2. `_php_serve` (private)

Serve given local directory with PHP

> Synopsis:
> _php_serve &lt;DOCROOT&gt; [IP] [PORT]
- `DOCROOT`: _(type: "folder")_ The path to the root directory.
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Defaults to "8080"._

- ⚠️ Requires: `php`
- 🔗 Depends: `_check_installed`, `echo_danger`, `echo_info`

#### ⌨️ 3. `_py_serve` (private)

Serve given local directory with Python 3

> Synopsis:
> _py_serve &lt;DOCROOT&gt; [IP] [PORT]
- `DOCROOT`: _(type: "folder")_ The path to the root directory.
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Defaults to "8080"._

- ⚠️ Requires: `python3`
- 🔗 Depends: `_check_installed`, `echo_danger`, `echo_info`

#### ⌨️ 4. `_remove_host` (private)

Remove hostname from /etc/hosts

> Synopsis:
> _remove_host &lt;HOSTNAME&gt;
- `HOSTNAME`: _(type: "str")_ The hostame to unset locally.

- 🔗 Depends: `_sed_i`, `echo_danger`, `echo_info`

#### ⌨️ 5. `_set_host` (private)

Set new host in /etc/hosts

> Synopsis:
> _set_host &lt;HOSTNAME&gt;
- `HOSTNAME`: _(type: "str")_ The hostame to set locally.

- 🔗 Depends: `_remove_host`, `echo_danger`, `echo_info`

### ⚡ PROMPTS

#### ⌨️ 1. `_select` (private)

Present user with a list of choices and prompt them to select one

> Synopsis:
> _select &lt;CHOICES&gt;
- `CHOICES`: _(type: "str")_ Array containing choices.

- 🔗 Depends: `echo_danger`, `echo_success`, `echo_warning`

#### ⌨️ 2. `_yes_no` (private)

Promt user for yes or no

> Synopsis:
> _yes_no [QUESTION]
- `QUESTION`: _(type: "str")_ (optional) A string containing the question. _Defaults to "Confirm ?"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_success`, `echo_warning`

### ⚡ REFLEXION

#### ⌨️ 1. `_get_constants` (private)

List constants from provided shoe script

> Synopsis:
> _get_constants &lt;SCRIPT_PATH&gt; [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private constants as well. _Defaults to "false"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 2. `_get_constraint` (private)

Get constaint for given variable from provided shoe script

> Synopsis:
> _get_constraint &lt;SCRIPT_PATH&gt; &lt;VARIABLE_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `VARIABLE_NAME`: _(type: "str")_ The variable to validate.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 3. `_get_flags` (private)

List flags from provided shoe script

> Synopsis:
> _get_flags &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 4. `_get_function_annotation` (private)

Get function annotation by name

> Synopsis:
> _get_function_annotation &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 5. `_get_function` (private)

Get function by name

> Synopsis:
> _get_function &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 6. `_get_functions_names` (private)

List functions names from provided shoe script

> Synopsis:
> _get_functions_names &lt;SCRIPT_PATH&gt; [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private functions as well. _Defaults to "false"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 7. `_get_options` (private)

List options from provided shoe script

> Synopsis:
> _get_options &lt;SCRIPT_PATH&gt; [GET_PRIVATE_ONLY]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE_ONLY`: _(type: "bool")_ (optional) If set to "true", retrieves private options only. _Defaults to "false"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 8. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script

> Synopsis:
> _get_padding &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 9. `_get_parameter` (private)

Get value for given parameter from provided ".env" or ".sh" file

> Synopsis:
> _get_parameter &lt;FILE_PATH&gt; &lt;KEY&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.

- ⚠️ Requires: `sed`
- 🔗 Depends: `echo_danger`, `echo_info`

#### ⌨️ 10. `_parse_annotation` (private)

Return function annotation as json

> Synopsis:
> _parse_annotation &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `jq`, `sed`
- 🔗 Depends: `_get_function_annotation`, `echo_danger`

#### ⌨️ 11. `_print_synopsis` (private)

Print function synopsis from a JSON string.

> Synopsis:
> _print_synopsis &lt;JSON&gt; [MARKDOWN_FORMAT]
- `JSON`: _(type: "json")_ The input string containing raw JSON.
- `MARKDOWN_FORMAT`: _(type: "bool")_ (optional) If set to "true", returns result as markdown. _Defaults to "false"._

- ⚠️ Requires: `jq`
- 🔗 Depends: `echo_danger`

#### ⌨️ 12. `_set_parameter` (private)

Set value for given parameter into provided file ".env" or ".sh" file

> Synopsis:
> _set_parameter &lt;FILE_PATH&gt; &lt;KEY&gt; &lt;VALUE&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.
- `VALUE`: _(type: "str")_ The value to be set to provided file.

- ⚠️ Requires: `sed`
- 🔗 Depends: `_sed_i`, `echo_danger`, `echo_info`, `echo_warning`

### ⚡ STRINGS

#### ⌨️ 1. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"

> Synopsis:
> _collapse_blank_lines &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- 🔗 Depends: `_sed_i`, `echo_danger`, `echo_info`

#### ⌨️ 2. `_generate_key` (private)

Generate random 32 bit string

> Synopsis:
> _generate_key

- ⚠️ Requires: `openssl`
- 🔗 Depends: `echo_info`

### ⚡ SYMFONY

#### ⌨️ 1. `_composer_install` (private)

Install project dependencies with composer

> Synopsis:
> _composer_install

- ⚠️ Requires: `composer`
- 🔗 Depends: `_check_installed`, `_pwd`, `echo_info`

#### ⌨️ 2. `_composer_update` (private)

Update project dependencies with composer

> Synopsis:
> _composer_update

- ⚠️ Requires: `composer`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 3. `_console` (private)

Get correct Symfony console binary path

> Synopsis:
> _console

- 🔗 Depends: `echo_danger`

#### ⌨️ 4. `_db_create` (private)

Create Symfony database with Doctrine

> Synopsis:
> _db_create [ENV]
- `ENV`: _(type: "str")_ (optional) Environment.

- 🔗 Depends: `_console`, `echo_info`

#### ⌨️ 5. `_db_drop` (private)

Drop database with Doctrine

> Synopsis:
> _db_drop [ENV]
- `ENV`: _(type: "str")_ (optional) Environment.

- 🔗 Depends: `_console`, `echo_info`

#### ⌨️ 6. `_db_query` (private)

Executes arbitrary SQL directly from the command line

> Synopsis:
> _db_query [SQL]
- `SQL`: _(type: "str")_ (optional) SQL query.

- 🔗 Depends: `_console`, `echo_info`

#### ⌨️ 7. `_db_schema` (private)

Create schema with Doctrine

> Synopsis:
> _db_schema [ENV]
- `ENV`: _(type: "str")_ (optional) Environment.

- 🔗 Depends: `_console`, `echo_info`

### ⚡ CI_CD

#### ⌨️ 1. `_phpunit` (private)

Get correct PHPUnit binary path

> Synopsis:
> _phpunit

- 🔗 Depends: `echo_danger`

### ⚡ SYMFONY

#### ⌨️ 1. `_sf_cache` (private)

Clear Symfony cache

> Synopsis:
> _sf_cache [ENV]
- `ENV`: _(type: "str")_ (optional) Environment.

- 🔗 Depends: `_console`, `echo_info`

#### ⌨️ 2. `_sf_lint` (private)

Run linter (sniff)

> Synopsis:
> _sf_lint

- ⚠️ Requires: `composer`, `php`
- 🔗 Depends: `_check_installed`, `_console`, `echo_info`

#### ⌨️ 3. `_security` (private)

Check security issues in project dependencies (symfony-cli)

> Synopsis:
> _security

- ⚠️ Requires: `composer`, `symfony`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 4. `_sf_serve` (private)

Run a local web server with Symfony CLI

> Synopsis:
> _sf_serve

- ⚠️ Requires: `symfony`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 5. `_sf_test` (private)

Run test with PHPUnit

> Synopsis:
> _sf_test [FILE_PATH]
- `FILE_PATH`: _(type: "file")_ (optional) The path to the input file.

- ⚠️ Requires: `php`
- 🔗 Depends: `_phpunit`, `echo_danger`, `echo_info`

### ⚡ SYSTEM

#### ⌨️ 1. `_check_installed` (private)

Print error message if provided command is missing

> Synopsis:
> _check_installed &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- 🔗 Depends: `_get_package_name`, `_is_installed`, `echo_danger`

#### ⌨️ 2. `_get_package_manager` (private)

Print default package manager

> Synopsis:
> _get_package_manager

- 🔗 Depends: `_is_installed`, `echo_danger`

#### ⌨️ 3. `_get_package_name` (private)

Find package name for given command

> Synopsis:
> _get_package_name &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- 🔗 Depends: `echo_danger`

#### ⌨️ 4. `_is_checksum_valid` (private)

Validate a file checksum

> Synopsis:
> _is_checksum_valid &lt;FILE_PATH&gt; &lt;SHA256SUM&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `SHA256SUM`: _(type: "str")_ A string containing file checksum.

- ⚠️ Requires: `awk`, `sha256sum`

#### ⌨️ 5. `_is_gnome` (private)

Check current desktop is gnome

> Synopsis:
> _is_gnome

#### ⌨️ 6. `_is_installed` (private)

Check provided command is installed

> Synopsis:
> _is_installed &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `dpkg`
- 🔗 Depends: `echo_danger`

#### ⌨️ 7. `_is_root` (private)

Check current user is root

> Synopsis:
> _is_root

- ⚠️ Requires: `awk`, `id`

#### ⌨️ 8. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally

> Synopsis:
> _pwd

#### ⌨️ 9. `_remove` (private)

Remove given package from system

> Synopsis:
> _remove &lt;PACKAGE&gt; [PACKAGE_MANAGER]
- `PACKAGE`: _(type: "str")_ The command/package to remove.
- `PACKAGE_MANAGER`: _(type: "str")_ (optional) The package manager required to remove the package with. _Defaults to "apt"._

- ⚠️ Requires: `apt`
- 🔗 Depends: `_get_package_manager`, `_get_package_name`, `_is_installed`, `echo_danger`, `echo_info`

#### ⌨️ 10. `_require` (private)

Install required package globally

> Synopsis:
> _require &lt;PACKAGE&gt; [PACKAGE_MANAGER]
- `PACKAGE`: _(type: "str")_ The command/package to remove.
- `PACKAGE_MANAGER`: _(type: "str")_ (optional) The package manager required to remove the package with. _Defaults to "apt"._

- ⚠️ Requires: `apt`
- 🔗 Depends: `_get_package_manager`, `_get_package_name`, `_is_installed`, `echo_danger`, `echo_info`

#### ⌨️ 11. `_spin` (private)

Animate a spinner in the terminal for a given amout of time

> Synopsis:
> _spin [DURATION]
- `DURATION`: _(type: "int")_ (optional) Animation duration in miliseconds. _Defaults to "0"._

- ⚠️ Requires: `awk`

#### ⌨️ 12. `_user_exists` (private)

Check provided user exists

> Synopsis:
> _user_exists &lt;USERNAME&gt;
- `USERNAME`: _(type: "str")_ The username to check.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

### ⚡ VALIDATION

#### ⌨️ 1. `_is_valid` (private)

Checks if variable is valid given regex constraint

> Synopsis:
> _is_valid &lt;VALUE&gt; &lt;PATTERN&gt;
- `VALUE`: _(type: "str")_ The string to be compared to regex pattern.
- `PATTERN`: _(type: "str")_ The regex parttern to apply.

- ⚠️ Requires: `grep`, `sed`
- 🔗 Depends: `echo_danger`

#### ⌨️ 2. `_validate` (private)

Find constraints and validates a variable

> Synopsis:
> _validate &lt;VARIABLE&gt;
- `VARIABLE`: _(type: "str")_ The variable to validate in the followling format : variable_name=value.

- ⚠️ Requires: `sed`
- 🔗 Depends: `_get_constraint`, `_is_valid`, `echo_danger`

### ⚡ KERNEL

#### ⌨️ 1. `_kernel` (private)

Shoe Kernel

> Synopsis:
> _kernel

- ⚠️ Requires: `awk`, `grep`
- 🔗 Depends: `_after`, `_before`, `_default`, `_get_flags`, `_get_functions_names`, `_get_options`, `_validate`, `echo_danger`

