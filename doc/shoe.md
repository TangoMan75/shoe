# TangoMan Shoe

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version:  0.1.0
- link:  https://github.com/TangoMan75/shoe

## 📑 Description

Simplify your shell scripting workflow with self-documenting
shell scripts with robust argument validation. Just prefix a
comment with two pound signs (##) on the line above any
function or variable to generate helpful documentation using
the "help" command.
Warning: Functions and variables names should not contain dashes.

## 🔥 Usage

`sh shoe.sh [command]`

## 🤖 Commands

### ⚡ SRC/SHELL/ANDROID

#### ⌨️ 1. `_adb_connect` (private)

Connect to device with adb via wifi (not recommended when flashing images)

> Synopsis:
> `_adb_connect <IP> [PORT]`
- `IP`: _(type: "str")_ Device IP address. _Constraint: `/^([0-9]{1,3}\.){3}[0-9]{1,3}$/`._
- `PORT`: _(type: "int")_ (optional) Destination port. _Constraint: `/^[0-9]{1,5}$/`._ _Defaults to "5555"._

- ⚠️ Requires: `adb`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 2. `_adb_sideload` (private)

Sideload given full OTA package to connected device

> Synopsis:
> `_adb_sideload <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `adb`, `realpath`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 3. `_adb_start_server` (private)

Start local adb server

> Synopsis:
> `_adb_start_server`

- ⚠️ Requires: `adb`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 4. `_fastboot_lock` (private)

Lock bootloader and flashing

> Synopsis:
> `_fastboot_lock`

- ⚠️ Requires: `fastboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 5. `_fastboot_unlock` (private)

Unlock bootloader and flashing

> Synopsis:
> `_fastboot_unlock`

- ⚠️ Requires: `fastboot`, `true`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 6. `_fastboot_wipe` (private)

Wipe userdata on connected device

> Synopsis:
> `_fastboot_wipe`

- ⚠️ Requires: `fastboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 7. `_flash_img` (private)

Flash img file to connected device provided partition

> Synopsis:
> `_flash_img <FILE_PATH> <PARTITION> [FORCE]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PARTITION`: _(type: "str")_ The name of the target partition.
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

- ⚠️ Requires: `fastboot`, `realpath`, `true`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 8. `_get_apk_label` (private)

Get APK label

> Synopsis:
> `_get_apk_label <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `aapt`, `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 9. `_get_apk_package_name` (private)

Get APK package_name

> Synopsis:
> `_get_apk_package_name <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `aapt`, `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 10. `_get_apk_path` (private)

Get installed APK path on connected device from package name

> Synopsis:
> `_get_apk_path <PACKAGE_NAME>`
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"

- ⚠️ Requires: `adb`, `awk`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb.sh`, `src/shell/colors/_echo_error.sh`

#### ⌨️ 11. `_get_apk_version` (private)

Get APK version

> Synopsis:
> `_get_apk_version <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `aapt`, `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 12. `_install_apk` (private)

Install APK on connected device

> Synopsis:
> `_install_apk <FILE_PATH> [FORCE] [--grant-all]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._
- `--grant-all`: Grant all runtime permissions.

- ⚠️ Requires: `adb`, `install`, `realpath`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 13. `_is_apk_installed` (private)

Check if package is installed on connected device

> Synopsis:
> `_is_apk_installed <PACKAGE_NAME>`
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"

- ⚠️ Requires: `adb`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb.sh`, `src/shell/colors/_echo_error.sh`

#### ⌨️ 14. `_is_device_connected_with_adb` (private)

Check device is connected with adb

> Synopsis:
> `_is_device_connected_with_adb`

- ⚠️ Requires: `adb`, `grep`, `sed`

- 🔗 Depends: `src/shell/system/_check_installed.sh`

#### ⌨️ 15. `_is_device_connected_with_fastboot` (private)

Check device is connected with fastboot

> Synopsis:
> `_is_device_connected_with_fastboot`

- ⚠️ Requires: `fastboot`

- 🔗 Depends: `src/shell/system/_check_installed.sh`

#### ⌨️ 16. `_list_installed_apks` (private)

List installed packages on connected device

> Synopsis:
> `_list_installed_apks`

- ⚠️ Requires: `adb`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb.sh`, `src/shell/colors/_echo_error.sh`

#### ⌨️ 17. `_pull_apk` (private)

Copy APK from connected device to local folder

> Synopsis:
> `_pull_apk <PACKAGE_NAME> <DESTINATION>`
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.

- ⚠️ Requires: `adb`, `realpath`

- 🔗 Depends: `src/shell/android/_get_apk_path.sh`, `src/shell/android/_is_device_connected_with_adb.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 18. `_reboot_bootloader` (private)

Reboot connected device to bootloader

> Synopsis:
> `_reboot_bootloader`

- ⚠️ Requires: `adb`, `fastboot`, `reboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb.sh`, `src/shell/android/_is_device_connected_with_fastboot.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 19. `_reboot_recovery` (private)

Reboot connected device to recovery

> Synopsis:
> `_reboot_recovery`

- ⚠️ Requires: `adb`, `fastboot`, `reboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb.sh`, `src/shell/android/_is_device_connected_with_fastboot.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 20. `_reboot_system` (private)

Reboot connected device to system

> Synopsis:
> `_reboot_system`

- ⚠️ Requires: `adb`, `fastboot`, `reboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb.sh`, `src/shell/android/_is_device_connected_with_fastboot.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 21. `_reboot_with_img` (private)

Boot connected device with given image temporarily

> Synopsis:
> `_reboot_with_img <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `fastboot`, `realpath`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 22. `_remove_apk` (private)

Remove APK from connected device

> Synopsis:
> `_remove_apk <PACKAGE_NAME> [FORCE]`
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

- ⚠️ Requires: `adb`, `true`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 23. `_toggle_active_slot` (private)

Toggle connected device active slot

> Synopsis:
> `_toggle_active_slot`

- ⚠️ Requires: `fastboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

### ⚡ SRC/SHELL/COLORS

#### ⌨️ 24. `_alert_danger` (private)

Print danger alert

> Synopsis:
> `_alert_danger <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 25. `_alert_dark` (private)

Print dark alert

> Synopsis:
> `_alert_dark <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 26. `_alert_info` (private)

Print info alert

> Synopsis:
> `_alert_info <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 27. `_alert_light` (private)

Print light alert

> Synopsis:
> `_alert_light <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 28. `_alert_muted` (private)

Print muted alert

> Synopsis:
> `_alert_muted <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 29. `_alert_primary` (private)

Print primary alert

> Synopsis:
> `_alert_primary <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 30. `_alert_secondary` (private)

Print secondary alert

> Synopsis:
> `_alert_secondary <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 31. `_alert_success` (private)

Print success alert

> Synopsis:
> `_alert_success <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 32. `_alert_warning` (private)

Print warning alert

> Synopsis:
> `_alert_warning <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 33. `_echo_danger` (private)

Print danger text with optional indentation and padding

> Synopsis:
> `_echo_danger <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 34. `_echo_dark` (private)

Print dark text with optional indentation and padding

> Synopsis:
> `_echo_dark <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 35. `_echo_error` (private)

Print error message to STDERR, prefixed with "error: "

> Synopsis:
> `_echo_error <MESSAGE>`
- `MESSAGE`: _(type: "str")_ Error message to display.

- ⚠️ Requires: `printf`

#### ⌨️ 36. `_echo_info` (private)

Print info text with optional indentation and padding

> Synopsis:
> `_echo_info <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 37. `_echo_light` (private)

Print light text with optional indentation and padding

> Synopsis:
> `_echo_light <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 38. `_echo_muted` (private)

Print muted text with optional indentation and padding

> Synopsis:
> `_echo_muted <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 39. `_echo_primary` (private)

Print primary text with optional indentation and padding

> Synopsis:
> `_echo_primary <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 40. `_echo_secondary` (private)

Print secondary text with optional indentation and padding

> Synopsis:
> `_echo_secondary <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 41. `_echo_success` (private)

Print success text with optional indentation and padding

> Synopsis:
> `_echo_success <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 42. `_echo_warning` (private)

Print warning text with optional indentation and padding

> Synopsis:
> `_echo_warning <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

### ⚡ SRC/SHELL/COMPATIBILITY

#### ⌨️ 43. `_clipboard` (private)

Return the command that copies stdin to the system clipboard

> Synopsis:
> `_clipboard`

- ⚠️ Requires: `command`, `printf`, `wl-copy`, `xclip`, `xsel`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 44. `_is_android` (private)

Check current system is Android

> Synopsis:
> `_is_android`

- ⚠️ Requires: `uname`

#### ⌨️ 45. `_is_bsd` (private)

Check current system is BSD

> Synopsis:
> `_is_bsd`

- ⚠️ Requires: `uname`

#### ⌨️ 46. `_is_cygwin` (private)

Check current system is Cygwin

> Synopsis:
> `_is_cygwin`

- ⚠️ Requires: `uname`

#### ⌨️ 47. `_is_darwin` (private)

Check current system is Darwin

> Synopsis:
> `_is_darwin`

- ⚠️ Requires: `uname`

#### ⌨️ 48. `_is_gnome` (private)

Check current desktop is gnome

> Synopsis:
> `_is_gnome`

#### ⌨️ 49. `_is_linux` (private)

Check current system is Linux

> Synopsis:
> `_is_linux`

- ⚠️ Requires: `uname`

#### ⌨️ 50. `_is_msys` (private)

Check current system is MSYS or MINGW

> Synopsis:
> `_is_msys`

- ⚠️ Requires: `uname`

#### ⌨️ 51. `_is_termux` (private)

Check current environment is Termux

> Synopsis:
> `_is_termux`

#### ⌨️ 52. `_is_wsl` (private)

Check current system is Windows Subsystem for Linux

> Synopsis:
> `_is_wsl`

- ⚠️ Requires: `grep`

#### ⌨️ 53. `_mktemp` (private)

Create a temporary file and print its path

> Synopsis:
> `_mktemp [PREFIX] [DIRECTORY]`
- `PREFIX`: _(type: "str")_ (optional) Prefix of the temporary file name, or a complete template ending with "XXXXXX". _Defaults to "tmp"._
- `DIRECTORY`: _(type: "folder")_ (optional) Folder receiving the temporary file. Ignored when a complete template is given. _Defaults to "/tmp"._

- ⚠️ Requires: `mktemp`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 54. `_open` (private)

Return the command that opens a file or URL with the default handler

> Synopsis:
> `_open`

- ⚠️ Requires: `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/compatibility/_os_type.sh`

#### ⌨️ 55. `_os_type` (private)

Print the current operating system type

> Synopsis:
> `_os_type`

- ⚠️ Requires: `printf`, `uname`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 56. `_package_manager` (private)

Print the default package manager for the current operating system

> Synopsis:
> `_package_manager`

- ⚠️ Requires: `apk`, `apt`, `apt-get`, `aptitude`, `command`, `dnf`, `flatpak`, `nala`, `pacman`, `printf`, `snap`, `yum`, `zypper`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/compatibility/_is_termux.sh`, `src/shell/compatibility/_os_type.sh`

#### ⌨️ 57. `_readlink` (private)

Return the command that resolves a canonical path

> Synopsis:
> `_readlink`

- ⚠️ Requires: `command`, `printf`, `readlink`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 58. `_sed_i` (private)

Edit a file in place with the system sed

> Synopsis:
> `_sed_i <EXPRESSION> <FILE_PATH>`
- `EXPRESSION`: _(type: "str")_ The sed expression.
- `FILE_PATH`: _(type: "file")_ The file to edit.

- ⚠️ Requires: `command`, `sed`, `uname`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 59. `_sha256` (private)

Return the command that computes a SHA-256 digest

> Synopsis:
> `_sha256`

- ⚠️ Requires: `command`, `openssl`, `printf`, `sha256sum`, `shasum`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

### ⚡ SRC/SHELL/DEV

#### ⌨️ 60. `_list_ides` (private)

List installed ides

> Synopsis:
> `_list_ides`

- ⚠️ Requires: `code`, `command`, `nano`, `phpstorm`, `printf`, `subl`, `vim`

### ⚡ SRC/SHELL/DOCKER

#### ⌨️ 61. `_docker_compose` (private)

Return docker compose command

> Synopsis:
> `_docker_compose`

- ⚠️ Requires: `command`, `docker`, `docker-compose`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 62. `_docker_compose_build` (private)

Build container stack with docker compose

> Synopsis:
> `_docker_compose_build [FILE_PATH]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/docker/_docker_compose.sh`

#### ⌨️ 63. `_docker_compose_start` (private)

Build and start container stack with docker compose

> Synopsis:
> `_docker_compose_start [FILE_PATH] [ENV_FILE]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.
- `ENV_FILE`: _(type: "file")_ (optional) The path to the env file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/docker/_docker_compose.sh`

#### ⌨️ 64. `_docker_compose_stop` (private)

Stop container stack with docker compose

> Synopsis:
> `_docker_compose_stop [FILE_PATH]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/docker/_docker_compose.sh`

#### ⌨️ 65. `_docker_exec` (private)

Execute command in the given docker container

> Synopsis:
> `_docker_exec <CONTAINER_NAME> <COMMAND> [USER]`
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.
- `COMMAND`: _(type: "str")_ The command to execute.
- `USER`: _(type: "str")_ (optional) The user name.

- ⚠️ Requires: `docker`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 66. `_docker_kill_all` (private)

Kill all running containers with docker

> Synopsis:
> `_docker_kill_all`

- ⚠️ Requires: `docker`, `kill`, `ps`, `tr`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 67. `_docker_rm` (private)

Remove given docker container

> Synopsis:
> `_docker_rm <CONTAINER_NAME>`
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.

- ⚠️ Requires: `docker`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 68. `_docker_run` (private)

Spawn a new container with given image, name, command and volume

> Synopsis:
> `_docker_run <IMAGE> <NAME> <COMMAND> [FOLDER_PATH]`
- `IMAGE`: _(type: "str")_ The name of the container image to run.
- `NAME`: _(type: "str")_ Assign a name to the container.
- `COMMAND`: _(type: "str")_ The command to run inside provided container.
- `FOLDER_PATH`: _(type: "folder")_ (optional) The path to the volume folder.

- ⚠️ Requires: `docker`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 69. `_docker_run_atmoz_sftp` (private)

Run local atmoz_sftp server

> Synopsis:
> `_docker_run_atmoz_sftp <USERNAME> <PASSWORD> [NETWORK_MODE] [FOLDER_PATH]`
- `USERNAME`: _(type: "str")_ The name of the container to run.
- `PASSWORD`: _(type: "str")_ The password for the sftp server access.
- `NETWORK_MODE`: _(type: "str")_ (optional) The user name. _Constraint: `/^(bridge|host)$/`._
- `FOLDER_PATH`: _(type: "folder")_ (optional) The path to the volume folder.

- ⚠️ Requires: `docker`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 70. `_docker_run_whoami` (private)

Run local whoami server

> Synopsis:
> `_docker_run_whoami`

- ⚠️ Requires: `docker`, `whoami`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 71. `_docker_status` (private)

Print docker status

> Synopsis:
> `_docker_status`

- ⚠️ Requires: `column`, `docker`, `ps`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 72. `_find_container_name` (private)

Find container name from string

> Synopsis:
> `_find_container_name <STRING>`
- `STRING`: _(type: "str")_ The string to find among running containers.

- ⚠️ Requires: `docker`, `grep`, `head`, `printf`, `ps`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 73. `_get_container_id` (private)

Get container id from name

> Synopsis:
> `_get_container_id <CONTAINER_NAME> [TRUNCATE]`
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.
- `TRUNCATE`: _(type: "bool")_ (optional) Truncate id to 12 characters long. _Defaults to "true"._

- ⚠️ Requires: `docker`, `false`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 74. `_get_container_ip` (private)

Get running container ip

> Synopsis:
> `_get_container_ip <CONTAINER>`
- `CONTAINER`: _(type: "str")_ The name or the id of the docker container.

- ⚠️ Requires: `docker`, `printf`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 75. `_get_container_name` (private)

Get container name from id

> Synopsis:
> `_get_container_name <CONTAINER_ID>`
- `CONTAINER_ID`: _(type: "str")_ The container id.

- ⚠️ Requires: `docker`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 76. `_is_container_running` (private)

Checks if given container is running

> Synopsis:
> `_is_container_running <CONTAINER>`
- `CONTAINER`: _(type: "str")_ The name or the id of the docker container.

- ⚠️ Requires: `docker`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 77. `_wait_for_postgres` (private)

Wait for postgresql container to start with docker

> Synopsis:
> `_wait_for_postgres <CONTAINER_NAME> [USERNAME]`
- `CONTAINER_NAME`: _(type: "str")_ The name of the docker container.
- `USERNAME`: _(type: "str")_ (optional) The psql username. _Defaults to ""._

- ⚠️ Requires: `docker`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/system/_check_installed.sh`, `src/shell/system/_spin.sh`

#### ⌨️ 78. `_wait_for_rabbit` (private)

Wait for rabbitmq container to start with docker

> Synopsis:
> `_wait_for_rabbit <CONTAINER_NAME>`
- `CONTAINER_NAME`: _(type: "str")_ The name of the docker container.

- ⚠️ Requires: `docker`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/system/_check_installed.sh`, `src/shell/system/_spin.sh`

### ⚡ Documentation

#### ⌨️ 79. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script

> Synopsis:
> `_generate_doc <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", documents private constants, options, flags, and commands as well. _Defaults to "false"._

- ⚠️ Requires: `awk`, `basename`, `dirname`, `false`, `printf`, `realpath`, `sed`, `true`

- 🔗 Depends: `src/shell/colors/_alert_primary.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/reflexion/_get_constants.sh`, `src/shell/reflexion/_get_flags.sh`, `src/shell/reflexion/_get_functions_names.sh`, `src/shell/reflexion/_get_options.sh`, `src/shell/reflexion/_print_synopsis.sh`, `src/shell/shoedoc/_get_function_shoedoc.sh`, `src/shell/shoedoc/_get_script_shoedoc.sh`, `src/shell/shoedoc/_get_shoedoc_description.sh`, `src/shell/shoedoc/_get_shoedoc_tag.sh`, `src/shell/shoedoc/_get_shoedoc_title.sh`

#### ⌨️ 80. `generate_doc` (public)

Generate Markdown documentation for current shoe script

> Synopsis:
> `generate_doc`

- 🔗 Depends: `src/shell/documentation/_generate_doc.sh`

#### ⌨️ 81. `_create_env` (private)

Create a ".env" file when missing

> Synopsis:
> `_create_env <FILE_PATH> [TEMPLATE]`
- `FILE_PATH`: _(type: "file")_ The path of the ".env" file to create.
- `TEMPLATE`: _(type: "file")_ (optional) Optional template file to copy into the new file.

- ⚠️ Requires: `cp`, `dirname`, `mkdir`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 82. `_load_dotenv` (private)

Load the first dotenv file found for an environment

> Synopsis:
> `_load_dotenv <ENV> [DIRECTORY]`
- `ENV`: _(type: "str")_ The application environment name.
- `DIRECTORY`: _(type: "folder")_ (optional) The folder containing the dotenv files. _Defaults to "."._

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/env/_load_env.sh`

#### ⌨️ 83. `_load_env` (private)

Load environment variables from a ".env" file

> Synopsis:
> `_load_env <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path of the ".env" file to load.

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 84. `_change_extension` (private)

Change the extension of a file

> Synopsis:
> `_change_extension <SOURCE> <EXTENSION>`
- `SOURCE`: _(type: "file")_ The file to rename.
- `EXTENSION`: _(type: "str")_ The extension to apply. _Constraint: `/^\.[a-zA-Z0-9]+$/`._

- ⚠️ Requires: `basename`, `dirname`, `mv`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 85. `_clean_folder` (private)

Recursively delete common junk files and folders

> Synopsis:
> `_clean_folder <SOURCE>`
- `SOURCE`: _(type: "folder")_ The folder to clean.

- ⚠️ Requires: `find`, `realpath`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 86. `_compress` (private)

Compress a file or folder into an archive

> Synopsis:
> `_compress <SOURCE> [DESTINATION] [-r]`
- `SOURCE`: _(type: "path")_ The file or folder to compress.
- `DESTINATION`: _(type: "folder")_ (optional) The folder receiving the archives. _Defaults to "current folder"._
- `-r`: Create one archive per direct subfolder.

- ⚠️ Requires: `basename`, `command`, `dirname`, `find`, `grep`, `printf`, `realpath`, `sed`, `sort`, `tar`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 87. `_extract` (private)

Extract file based on its extension

> Synopsis:
> `_extract <FILE_PATH> [DESTINATION]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.

- ⚠️ Requires: `dirname`, `realpath`, `tar`, `unzip`, `zip`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 88. `_get_file_extension` (private)

Get file extension

> Synopsis:
> `_get_file_extension <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 89. `_get_size` (private)

Print the human readable size of a file or folder

> Synopsis:
> `_get_size <SOURCE>`
- `SOURCE`: _(type: "path")_ The file or folder to measure.

- ⚠️ Requires: `du`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 90. `_move` (private)

Move file or folder to destination (creates folder when missing)

> Synopsis:
> `_move <SOURCE> <DESTINATION>`
- `SOURCE`: _(type: "path")_ The path to the input file or folder.
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.

- ⚠️ Requires: `cp`, `mkdir`, `mv`, `realpath`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 91. `_blob_exists` (private)

Check if a git blob exists in the repository

> Synopsis:
> `_blob_exists <BLOB_HASH> [-v]`
- `BLOB_HASH`: _(type: "str")_ The git blob hash to check.
- `-v`: Print the command before execution.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 92. `_branch_exists` (private)

Check if a git branch exists in the local or remote repository

> Synopsis:
> `_branch_exists <BRANCH> [-a] [-r] [-v]`
- `BRANCH`: _(type: "str")_ The branch name to check.
- `-a`: Search all references.
- `-r`: Search remote branches only.
- `-v`: Print the command before execution.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 93. `_check_branch_is_valid` (private)

Check if a git branch name is valid

> Synopsis:
> `_check_branch_is_valid <BRANCH>`
- `BRANCH`: _(type: "str")_ The branch name to validate.

- ⚠️ Requires: `printf`, `tr`

#### ⌨️ 94. `_check_commit_is_valid` (private)

Check if a commit hash is valid

> Synopsis:
> `_check_commit_is_valid <COMMIT>`
- `COMMIT`: _(type: "str")_ The commit hash to validate.

- ⚠️ Requires: `printf`, `tr`

#### ⌨️ 95. `_commit_exists` (private)

Check if a git commit exists in the repository

> Synopsis:
> `_commit_exists <COMMIT_HASH> [-v]`
- `COMMIT_HASH`: _(type: "str")_ The commit hash to check.
- `-v`: Print the command before execution.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 96. `_format_branch_subject` (private)

Format a branch subject

> Synopsis:
> `_format_branch_subject <SUBJECT>`
- `SUBJECT`: _(type: "str")_ The branch subject to format.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 97. `_format_commit_subject` (private)

Format a commit subject

> Synopsis:
> `_format_commit_subject <SUBJECT>`
- `SUBJECT`: _(type: "str")_ The commit subject to format.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 98. `_format_ticket` (private)

Format a ticket identifier

> Synopsis:
> `_format_ticket <TICKET>`
- `TICKET`: _(type: "str")_ The ticket identifier to format.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 99. `_format_type` (private)

Format a conventional commit type

> Synopsis:
> `_format_type <TYPE>`
- `TYPE`: _(type: "str")_ The commit type to format.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 100. `_get_branch_subject` (private)

Get branch subject

> Synopsis:
> `_get_branch_subject`

- ⚠️ Requires: `HEAD`, `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/git/_parse_branch_subject.sh`

#### ⌨️ 101. `_get_branch_ticket` (private)

Get branch ticket

> Synopsis:
> `_get_branch_ticket`

- ⚠️ Requires: `HEAD`, `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/git/_parse_branch_ticket.sh`

#### ⌨️ 102. `_get_branch_type` (private)

Get branch type

> Synopsis:
> `_get_branch_type`

- ⚠️ Requires: `HEAD`, `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/git/_parse_branch_type.sh`

#### ⌨️ 103. `_get_commit_body` (private)

Get commit body

> Synopsis:
> `_get_commit_body`

- ⚠️ Requires: `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/strings/_trim.sh`

#### ⌨️ 104. `_get_commit_pull_request` (private)

Get commit pull request

> Synopsis:
> `_get_commit_pull_request`

- ⚠️ Requires: `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/git/_parse_commit_pull_request.sh`

#### ⌨️ 105. `_get_commit_scope` (private)

Get commit scope

> Synopsis:
> `_get_commit_scope`

- ⚠️ Requires: `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/git/_parse_commit_scope.sh`

#### ⌨️ 106. `_get_commit_subject` (private)

Get commit subject

> Synopsis:
> `_get_commit_subject`

- ⚠️ Requires: `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/git/_parse_commit_subject.sh`

#### ⌨️ 107. `_get_commit_ticket` (private)

Get commit ticket id

> Synopsis:
> `_get_commit_ticket`

- ⚠️ Requires: `command`, `git`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/git/_get_branch_ticket.sh`, `src/shell/git/_parse_commit_ticket.sh`

#### ⌨️ 108. `_get_commit_type` (private)

Get commit type

> Synopsis:
> `_get_commit_type`

- ⚠️ Requires: `command`, `git`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/git/_get_branch_type.sh`, `src/shell/git/_parse_commit_type.sh`

#### ⌨️ 109. `_get_current_branch` (private)

Get the current git branch name

> Synopsis:
> `_get_current_branch [-v]`
- `-v`: Print the command before execution.

- ⚠️ Requires: `HEAD`, `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 110. `_get_git_remote_url` (private)

Print the web URL of a git remote

> Synopsis:
> `_get_git_remote_url [REMOTE]`
- `REMOTE`: _(type: "str")_ (optional) The name of the git remote. _Defaults to "origin"._

- ⚠️ Requires: `git`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 111. `_get_latest_release` (private)

Get repository latest release version from github

> Synopsis:
> `_get_latest_release <REPOSITORY>`
- `REPOSITORY`: _(type: "str")_ Owner and repository name in the form: owner/repository.

- ⚠️ Requires: `command`, `curl`, `printf`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 112. `_get_main_branch` (private)

Get main branch name

> Synopsis:
> `_get_main_branch [-v]`
- `-v`: Print the git command before executing it.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 113. `_git_hooks` (private)

Update .git/hooks folder

> Synopsis:
> `_git_hooks <SOURCE>`
- `SOURCE`: _(type: "folder")_ The source directory.

- ⚠️ Requires: `chmod`, `cp`, `git`, `realpath`, `rm`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 114. `_initialise_submodules` (private)

Initialise git submodules

> Synopsis:
> `_initialise_submodules`

- ⚠️ Requires: `git`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 115. `_is_cherry_pick_in_progress` (private)

Check if a git cherry-pick is in progress

> Synopsis:
> `_is_cherry_pick_in_progress [-v]`
- `-v`: Print the test command before executing it.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 116. `_is_rebase_in_progress` (private)

Check if a git rebase is in progress

> Synopsis:
> `_is_rebase_in_progress [-v]`
- `-v`: Print the test command before executing it.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 117. `_list_github` (private)

Lists user's GitHub repositories

> Synopsis:
> `_list_github <OWNER> [-v]`
- `OWNER`: _(type: "str")_ GitHub owner name.
- `-v`: Print command before execution.

- ⚠️ Requires: `command`, `curl`, `grep`, `jq`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 118. `_parse_branch_subject` (private)

Parse branch subject

> Synopsis:
> `_parse_branch_subject <BRANCH>`
- `BRANCH`: _(type: "str")_ The conventional branch name to parse.

- ⚠️ Requires: `grep`, `printf`

#### ⌨️ 119. `_parse_branch_ticket` (private)

Parse branch ticket

> Synopsis:
> `_parse_branch_ticket <BRANCH>`
- `BRANCH`: _(type: "str")_ The conventional branch name to parse.

- ⚠️ Requires: `printf`, `sed`

#### ⌨️ 120. `_parse_branch_type` (private)

Parse branch type

> Synopsis:
> `_parse_branch_type <BRANCH>`
- `BRANCH`: _(type: "str")_ The conventional branch name to parse.

- ⚠️ Requires: `printf`

#### ⌨️ 121. `_parse_commit_pull_request` (private)

Parse commit pull request number

> Synopsis:
> `_parse_commit_pull_request <COMMIT_MESSAGE>`
- `COMMIT_MESSAGE`: _(type: "str")_ The conventional commit message to parse.

- ⚠️ Requires: `printf`, `sed`

#### ⌨️ 122. `_parse_commit_scope` (private)

Parse commit scope

> Synopsis:
> `_parse_commit_scope <COMMIT_MESSAGE>`
- `COMMIT_MESSAGE`: _(type: "str")_ The conventional commit message to parse.

- ⚠️ Requires: `awk`, `command`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`

#### ⌨️ 123. `_parse_commit_subject` (private)

Parse commit subject

> Synopsis:
> `_parse_commit_subject <COMMIT_MESSAGE>`
- `COMMIT_MESSAGE`: _(type: "str")_ The conventional commit message to parse.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 124. `_parse_commit_ticket` (private)

Parse commit ticket

> Synopsis:
> `_parse_commit_ticket <COMMIT_MESSAGE>`
- `COMMIT_MESSAGE`: _(type: "str")_ The conventional commit message to parse.

- ⚠️ Requires: `printf`, `sed`

#### ⌨️ 125. `_parse_commit_type` (private)

Parse commit type

> Synopsis:
> `_parse_commit_type <COMMIT_MESSAGE>`
- `COMMIT_MESSAGE`: _(type: "str")_ The conventional commit message to parse.

- ⚠️ Requires: `awk`, `printf`

#### ⌨️ 126. `_pick_branch` (private)

Select a branch interactively from a list of git branches

> Synopsis:
> `_pick_branch [-F VALUE] [-a] [-c] [-m] [-v]`
- `-F`: _(type: "str")_ Grep filter applied to the branch list.
- `-a`: List all branches.
- `-c`: Include the current branch.
- `-m`: Include the main branch.
- `-v`: Print the command before execution.

- ⚠️ Requires: `HEAD`, `awk`, `command`, `git`, `grep`, `printf`, `rm`, `sed`, `true`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/compatibility/_mktemp.sh`, `src/shell/git/_get_main_branch.sh`

#### ⌨️ 127. `_pick_commit` (private)

Select a commit interactively from a list of git commits

> Synopsis:
> `_pick_commit [BRANCH] [-n VALUE] [-v]`
- `BRANCH`: _(type: "str")_ (optional) The branch to list commits from.
- `-n`: _(type: "int")_ The number of commits to list. _Defaults to "16"._
- `-v`: Print the command before execution.

- ⚠️ Requires: `awk`, `command`, `cut`, `git`, `grep`, `head`, `printf`, `rm`, `sed`, `true`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/compatibility/_mktemp.sh`

#### ⌨️ 128. `_pick_repository` (private)

Select a repository interactively from a GitHub user's repositories

> Synopsis:
> `_pick_repository <OWNER>`
- `OWNER`: _(type: "str")_ The GitHub user name.

- ⚠️ Requires: `awk`, `grep`, `printf`, `rm`, `sed`, `true`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/compatibility/_mktemp.sh`, `src/shell/git/_list_github.sh`

#### ⌨️ 129. `_print_jira_url` (private)

Print Jira URL

> Synopsis:
> `_print_jira_url <TICKET>`
- `TICKET`: _(type: "str")_ The Jira ticket identifier (e.g., FOO-123).

- ⚠️ Requires: `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 130. `_deploy` (private)

Deploy source folder to "gh-pages"

> Synopsis:
> `_deploy <SOURCE>`
- `SOURCE`: _(type: "folder")_ The source directory.

- ⚠️ Requires: `HEAD`, `git`, `split`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

### ⚡ Help

#### ⌨️ 131. `_help` (private)

Print help for a shoe script or one of its commands

> Synopsis:
> `_help <FILE_PATH> [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `COMMAND_NAME`: _(type: "str")_ (optional) The command name to get detailed help for.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_alert_primary.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/help/_print_command_details.sh`, `src/shell/help/_print_commands.sh`, `src/shell/help/_print_constants.sh`, `src/shell/help/_print_description.sh`, `src/shell/help/_print_flags.sh`, `src/shell/help/_print_infos.sh`, `src/shell/help/_print_options.sh`, `src/shell/help/_print_usage.sh`, `src/shell/reflexion/_get_constants.sh`, `src/shell/reflexion/_get_flags.sh`, `src/shell/reflexion/_get_options.sh`, `src/shell/reflexion/_get_padding.sh`, `src/shell/shoedoc/_get_function_shoedoc.sh`, `src/shell/shoedoc/_get_script_shoedoc.sh`, `src/shell/shoedoc/_get_shoedoc_description.sh`, `src/shell/shoedoc/_get_shoedoc_title.sh`

#### ⌨️ 132. `help` (public)

Print this help

> Synopsis:
> `help [COMMAND_NAME]`
- `COMMAND_NAME`: _(type: "str")_ (optional) The command name to print detailed help for.

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/help/_help.sh`

#### ⌨️ 133. `_print_command_details` (private)

Print detailed help for a given command

> Synopsis:
> `_print_command_details <FILE_PATH> <COMMAND_NAME> <ANNOTATIONS>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `COMMAND_NAME`: _(type: "str")_ The command name to document.
- `ANNOTATIONS`: _(type: "str")_ The shoedoc annotation block, classic @-tags.

- ⚠️ Requires: `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/help/_print_description.sh`, `src/shell/help/_print_flags.sh`, `src/shell/help/_print_options.sh`, `src/shell/help/_print_usage.sh`, `src/shell/reflexion/_get_padding.sh`, `src/shell/shoedoc/_get_shoedoc_description.sh`, `src/shell/shoedoc/_get_shoedoc_tag.sh`, `src/shell/shoedoc/_get_shoedoc_title.sh`

#### ⌨️ 134. `_print_commands` (private)

List commands of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_commands <FILE_PATH> [PADDING]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 135. `_print_constants` (private)

List constants of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_constants <FILE_PATH> [PADDING]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 136. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)

> Synopsis:
> `_print_description <DESCRIPTION>`
- `DESCRIPTION`: _(type: "str")_ A string containing script description.

- ⚠️ Requires: `fold`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 137. `_print_flags` (private)

List flags of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_flags <FILE_PATH> [PADDING] [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._
- `COMMAND_NAME`: _(type: "str")_ (optional) Optional command whose flags should be added.

- ⚠️ Requires: `awk`, `grep`, `printf`, `realpath`, `tr`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/reflexion/_get_flags.sh`, `src/shell/reflexion/_get_function_parameters.sh`

#### ⌨️ 138. `_print_infos` (private)

Print infos of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_infos <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/shoedoc/_get_script_shoedoc.sh`, `src/shell/shoedoc/_get_shoedoc_tag.sh`

#### ⌨️ 139. `_print_options` (private)

List options of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_options <FILE_PATH> [PADDING] [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._
- `COMMAND_NAME`: _(type: "str")_ (optional) Optional command whose options should be added.

- ⚠️ Requires: `awk`, `grep`, `printf`, `realpath`, `tr`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/reflexion/_get_function_parameters.sh`, `src/shell/reflexion/_get_options.sh`

#### ⌨️ 140. `_print_usage` (private)

Print usage of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_usage <FILE_PATH> [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `COMMAND_NAME`: _(type: "str")_ (optional) Optional command whose parameters should be added.

- ⚠️ Requires: `awk`, `basename`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/reflexion/_get_flags.sh`, `src/shell/reflexion/_get_function_parameters.sh`, `src/shell/reflexion/_get_options.sh`

#### ⌨️ 141. `_after` (private)

Place here commands you need executed last on success (optional)

> Synopsis:
> `_after`

#### ⌨️ 142. `_before` (private)

Place here commands you need executed first every time (optional)

> Synopsis:
> `_before`

- ⚠️ Requires: `awk`, `sed`

- 🔗 Depends: `src/shell/system/_check_installed.sh`

#### ⌨️ 143. `_default` (private)

Place here commands you need executed by default (optional)

> Synopsis:
> `_default`

- 🔗 Depends: `src/shell/help/help.sh`

### ⚡ Self Install

#### ⌨️ 144. `_copy_install` (private)

Install script via copy

> Synopsis:
> `_copy_install <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `cp`, `realpath`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/validation/_validate_alias.sh`

#### ⌨️ 145. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file

> Synopsis:
> `_generate_autocomplete <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `dirname`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/install/_get_comspec.sh`, `src/shell/validation/_validate_alias.sh`

#### ⌨️ 146. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file

> Synopsis:
> `_generate_global_autocomplete <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `printf`, `realpath`, `sudo`, `tee`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/install/_get_comspec.sh`, `src/shell/validation/_validate_alias.sh`

#### ⌨️ 147. `_get_comspec` (private)

Generate comspec string for the provided file

> Synopsis:
> `_get_comspec <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 148. `_install` (private)

Install script and enable autocompletion

> Synopsis:
> `_install <FILE_PATH> [ALIAS] [GLOBAL]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

- ⚠️ Requires: `basename`, `bash`, `realpath`, `touch`, `true`, `uname`, `zsh`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/install/_copy_install.sh`, `src/shell/install/_generate_autocomplete.sh`, `src/shell/install/_generate_global_autocomplete.sh`, `src/shell/install/_set_completion_autoload.sh`, `src/shell/install/_symlink_install.sh`, `src/shell/system/_is_installed.sh`

#### ⌨️ 149. `_remove_completion_autoload` (private)

Remove completion script autoload

> Synopsis:
> `_remove_completion_autoload <SHELL_CONFIG_FILE> [ALIAS]`
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `printf`, `realpath`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/compatibility/_sed_i.sh`

#### ⌨️ 150. `self_install` (public)

Install script and enable autocompletion

> Synopsis:
> `self_install`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_install.sh`

#### ⌨️ 151. `self_uninstall` (public)

Uninstall script from system

> Synopsis:
> `self_uninstall`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_uninstall.sh`

#### ⌨️ 152. `self_update` (public)

Update script from @update

> Synopsis:
> `self_update`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/install/_update.sh`, `src/shell/shoedoc/_get_script_shoedoc.sh`, `src/shell/shoedoc/_get_shoedoc_tag.sh`

#### ⌨️ 153. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file

> Synopsis:
> `_set_completion_autoload <SHELL_CONFIG_FILE> <SCRIPT_FILE_PATH> [ALIAS]`
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `SCRIPT_FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `dirname`, `printf`, `realpath`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/compatibility/_sed_i.sh`, `src/shell/strings/_collapse_blank_lines.sh`

#### ⌨️ 154. `_symlink_install` (private)

Install script via symlink

> Synopsis:
> `_symlink_install <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `ln`, `realpath`, `rm`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/validation/_validate_alias.sh`

#### ⌨️ 155. `_uninstall` (private)

Uninstall script from system

> Synopsis:
> `_uninstall <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `cmp`, `dirname`, `realpath`, `rm`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/install/_remove_completion_autoload.sh`

#### ⌨️ 156. `_update` (private)

Updates given script from the provided URL

> Synopsis:
> `_update <FILE_PATH> <URL> [ALIAS] [GLOBAL]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `URL`: _(type: "str")_ The URL of the script to download and install.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

- ⚠️ Requires: `basename`, `chmod`, `curl`, `grep`, `head`, `mv`, `realpath`, `rm`, `stat`, `wget`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/install/_install.sh`, `src/shell/install/_uninstall.sh`, `src/shell/system/_is_installed.sh`

### ⚡ Make

#### ⌨️ 157. `_generate_makefile` (private)

Generate Makefile for provided shoe script

> Synopsis:
> `_generate_makefile <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

- ⚠️ Requires: `awk`, `basename`, `cat`, `dirname`, `printf`, `realpath`, `tr`

- 🔗 Depends: `src/shell/colors/_alert_primary.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/shoedoc/_get_script_shoedoc.sh`, `src/shell/shoedoc/_get_shoedoc_description.sh`, `src/shell/shoedoc/_get_shoedoc_tag.sh`, `src/shell/shoedoc/_get_shoedoc_title.sh`

#### ⌨️ 158. `generate_makefile` (public)

Generate Makefile for current shoe script

> Synopsis:
> `generate_makefile`

- 🔗 Depends: `src/shell/make/_generate_makefile.sh`

#### ⌨️ 159. `_check_dns` (private)

Print the DNS records of a domain

> Synopsis:
> `_check_dns <DOMAIN> [-t VALUE]`
- `DOMAIN`: _(type: "str")_ The domain to check.
- `-t`: _(type: "str")_ The DNS record type to query. _Defaults to "A"._

- ⚠️ Requires: `awk`, `command`, `dig`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 160. `_download` (private)

Downloads file with either curl or wget

> Synopsis:
> `_download <URL> <FILE_PATH>`
- `URL`: _(type: "str")_ The URL of the file to download.
- `FILE_PATH`: _(type: "file")_ The path to the output file.

- ⚠️ Requires: `curl`, `dirname`, `grep`, `head`, `mkdir`, `wget`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_is_installed.sh`

#### ⌨️ 161. `_get_external_ip` (private)

Print the external IPv4 address of the current connection

> Synopsis:
> `_get_external_ip`

- ⚠️ Requires: `command`, `curl`, `printf`, `wget`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 162. `_list_adapters` (private)

List the network adapters available on the system

> Synopsis:
> `_list_adapters [-c] [-w] [-v]`
- `-c`: Only list adapters with a connected peer.
- `-w`: Only list wireless adapters.
- `-v`: Print the command before execution.

- ⚠️ Requires: `arp`, `awk`, `command`, `cut`, `grep`, `ifconfig`, `ip`, `iwconfig`, `printf`, `sed`, `sort`, `tr`, `true`, `uniq`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 163. `_open_in_default_browser` (private)

Open in default browser

> Synopsis:
> `_open_in_default_browser [IP] [PORT] [SCHEME]`
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Constraint: `/^[0-9]{1,5}$/`._ _Defaults to "8080"._
- `SCHEME`: _(type: "str")_ (optional) scheme - e.g. http. _Defaults to "http"._

- ⚠️ Requires: `nohup`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/compatibility/_open.sh`

#### ⌨️ 164. `_php_serve` (private)

Serve given local directory with PHP

> Synopsis:
> `_php_serve <DOCROOT> [IP] [PORT]`
- `DOCROOT`: _(type: "folder")_ The path to the root directory.
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Constraint: `/^[0-9]{1,5}$/`._ _Defaults to "8080"._

- ⚠️ Requires: `php`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 165. `_py_serve` (private)

Serve given local directory with Python 3

> Synopsis:
> `_py_serve <DOCROOT> [IP] [PORT]`
- `DOCROOT`: _(type: "folder")_ The path to the root directory.
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Constraint: `/^[0-9]{1,5}$/`._ _Defaults to "8080"._

- ⚠️ Requires: `python3`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 166. `_remove_host` (private)

Remove hostname from the local hosts file

> Synopsis:
> `_remove_host <HOSTNAME>`
- `HOSTNAME`: _(type: "str")_ The hostname to unset locally.

- ⚠️ Requires: `awk`, `cp`, `rm`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/compatibility/_mktemp.sh`

#### ⌨️ 167. `_set_host` (private)

Set new host in the local hosts file

> Synopsis:
> `_set_host <HOSTNAME>`
- `HOSTNAME`: _(type: "str")_ The hostname to set locally.

- ⚠️ Requires: `printf`, `sudo`, `tee`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/network/_remove_host.sh`

#### ⌨️ 168. `_npm_build` (private)

Build app to destination folder

> Synopsis:
> `_npm_build <DESTINATION>`
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.

- ⚠️ Requires: `npm`, `pwd`, `realpath`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 169. `_npm_lint` (private)

Lint source files

> Synopsis:
> `_npm_lint`

- ⚠️ Requires: `npm`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 170. `_npm_test` (private)

Run tests

> Synopsis:
> `_npm_test`

- ⚠️ Requires: `npm`, `test`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 171. `_npm_watch` (private)

Watch source folder for changes

> Synopsis:
> `_npm_watch`

- ⚠️ Requires: `npm`, `watch`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 172. `_select` (private)

Present user with a list of choices and prompt them to select one

> Synopsis:
> `_select <CHOICES>`
- `CHOICES`: _(type: "str")_ Array containing choices.

- ⚠️ Requires: `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 173. `_yes_no` (private)

Promt user for yes or no

> Synopsis:
> `_yes_no [QUESTION]`
- `QUESTION`: _(type: "str")_ (optional) A string containing the question. _Defaults to "Confirm ?"._

- ⚠️ Requires: `echo`, `grep`

- 🔗 Depends: `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 174. `_lint_with_autopep8` (private)

Format Python files in place with autopep8

> Synopsis:
> `_lint_with_autopep8`

- ⚠️ Requires: `autopep8`, `find`, `sort`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 175. `_lint_with_pycompile` (private)

Check Python files syntax with py_compile

> Synopsis:
> `_lint_with_pycompile`

- ⚠️ Requires: `find`, `python3`, `sort`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 176. `_lint_with_pylint` (private)

Lint Python files with pylint

> Synopsis:
> `_lint_with_pylint`

- ⚠️ Requires: `find`, `pylint`, `sort`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 177. `_lint_with_ruff` (private)

Lint Python files with ruff

> Synopsis:
> `_lint_with_ruff [-f|--fix]`
- `-f`, `--fix`: Autofix lint errors.

- ⚠️ Requires: `find`, `grep`, `printf`, `ruff`, `sort`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 178. `_get_constants` (private)

List constants from provided shoe script

> Synopsis:
> `_get_constants <SCRIPT_PATH> [GET_PRIVATE]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private constants as well. _Defaults to "false"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 179. `_get_constraint` (private)

Get constaint for given variable from provided shoe script

> Synopsis:
> `_get_constraint <SCRIPT_PATH> <VARIABLE_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `VARIABLE_NAME`: _(type: "str")_ The variable to validate.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 180. `_get_flags` (private)

List flags from provided shoe script

> Synopsis:
> `_get_flags <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 181. `_get_function` (private)

Get function by name

> Synopsis:
> `_get_function <SCRIPT_PATH> <FUNCTION_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 182. `_get_function_parameters` (private)

List parameters, options and flags declared in a function shoedoc annotation

> Synopsis:
> `_get_function_parameters <SCRIPT_PATH> <FUNCTION_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to inspect.
- Stdout: `one record per option or flag, fields separated by ASCII 31.`

- ⚠️ Requires: `awk`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/shoedoc/_get_function_shoedoc.sh`

#### ⌨️ 183. `_get_functions_names` (private)

List functions names from provided shoe script

> Synopsis:
> `_get_functions_names <SCRIPT_PATH> [GET_PRIVATE]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private functions as well. _Defaults to "false"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 184. `_get_options` (private)

List options from provided shoe script

> Synopsis:
> `_get_options <SCRIPT_PATH> [GET_PRIVATE_ONLY]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE_ONLY`: _(type: "bool")_ (optional) If set to "true", retrieves private options only. _Defaults to "false"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 185. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script

> Synopsis:
> `_get_padding <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 186. `_get_parameter` (private)

Get value for given parameter from provided ".env" or ".sh" file

> Synopsis:
> `_get_parameter <FILE_PATH> <KEY>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.

- ⚠️ Requires: `realpath`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 187. `_has_parameter` (private)

Tests if parameter exists in provided ".env" or ".sh" file

> Synopsis:
> `_has_parameter <FILE_PATH> <KEY>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.

- ⚠️ Requires: `grep`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 188. `_print_synopsis` (private)

Print function synopsis from shoedoc annotations

> Synopsis:
> `_print_synopsis <FUNCTION_NAME> <ANNOTATIONS> [MARKDOWN_FORMAT]`
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to document.
- `ANNOTATIONS`: _(type: "str")_ The shoedoc annotation block, classic @-tags.
- `MARKDOWN_FORMAT`: _(type: "bool")_ (optional) If set to "true", returns result as markdown. _Defaults to "false"._

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 189. `_set_parameter` (private)

Set a variable in a ".env" or ".sh" file

> Synopsis:
> `_set_parameter <FILE_PATH> <KEY> <VALUE> [FORCE]`
- `FILE_PATH`: _(type: "file")_ The ".env" file to update.
- `KEY`: _(type: "str")_ The variable name to set.
- `VALUE`: _(type: "str")_ The value to assign.
- `FORCE`: _(type: "bool")_ (optional) Append the variable when missing. _Defaults to "false"._

- ⚠️ Requires: `awk`, `chmod`, `dirname`, `grep`, `mktemp`, `mv`, `printf`, `rm`, `sed`, `stat`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 190. `_get_function_shoedoc` (private)

Get function shedoc annotation by name

> Synopsis:
> `_get_function_shoedoc <SCRIPT_PATH> <FUNCTION_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 191. `_get_script_shoedoc` (private)

Get top-level shoedoc annotation of the provided shoe script file

> Synopsis:
> `_get_script_shoedoc <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 192. `_get_shoedoc` (private)

Get shoedoc annotation

> Synopsis:
> `_get_shoedoc <TEXT>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 193. `_get_shoedoc_description` (private)

Get shoedoc description

> Synopsis:
> `_get_shoedoc_description <TEXT>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 194. `_get_shoedoc_tag` (private)

Return given tag values from shoedoc annotation

> Synopsis:
> `_get_shoedoc_tag <TEXT> <TAG_NAME>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.
- `TAG_NAME`: _(type: "str")_ The name of tag to return.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 195. `_get_shoedoc_title` (private)

Get shoedoc title

> Synopsis:
> `_get_shoedoc_title <TEXT>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 196. `_config_ssh_file_permissions` (private)

Set the expected permissions on the ~/.ssh folder

> Synopsis:
> `_config_ssh_file_permissions`

- ⚠️ Requires: `chmod`, `chown`, `find`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 197. `_is_gcr_ssh_agent` (private)

Check if the current ssh agent is gcr-ssh-agent

> Synopsis:
> `_is_gcr_ssh_agent`

#### ⌨️ 198. `_is_ssh_agent_running` (private)

Check if an ssh agent is running

> Synopsis:
> `_is_ssh_agent_running [SOCKET]`
- `SOCKET`: _(type: "str")_ (optional) The ssh agent socket path. _Defaults to "$SSH_AUTH_SOCK"._

- ⚠️ Requires: `ssh-add`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 199. `_list_ssh_identities` (private)

List the identities loaded in the ssh agent

> Synopsis:
> `_list_ssh_identities`

- ⚠️ Requires: `command`, `ssh-add`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 200. `_ssh_add_all_identities` (private)

Add every ssh identity found in ~/.ssh to the ssh agent

> Synopsis:
> `_ssh_add_all_identities`

- ⚠️ Requires: `command`, `find`, `printf`, `sed`, `ssh-add`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 201. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"

> Synopsis:
> `_collapse_blank_lines <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/compatibility/_sed_i.sh`

#### ⌨️ 202. `_decode_base64` (private)

Decode a base64 string

> Synopsis:
> `_decode_base64 <STRING>`
- `STRING`: _(type: "str")_ The base64 string to decode.

- ⚠️ Requires: `base64`, `command`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 203. `_dedupe_lines` (private)

Remove every line in target file that contains substrings from source file

> Synopsis:
> `_dedupe_lines <SOURCE_PATH> <TARGET_PATH>`
- `SOURCE_PATH`: _(type: "file")_ The path to the file containing the substrings to remove.
- `TARGET_PATH`: _(type: "file")_ The path to the target file to deduplicate.

- ⚠️ Requires: `printf`, `realpath`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/compatibility/_sed_i.sh`

#### ⌨️ 204. `_encode_base64` (private)

Encode a string to base64

> Synopsis:
> `_encode_base64 <STRING>`
- `STRING`: _(type: "str")_ The string to encode.

- ⚠️ Requires: `base64`, `command`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 205. `_generate_key` (private)

Generate random 32 bit string

> Synopsis:
> `_generate_key`

- ⚠️ Requires: `openssl`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 206. `_generate_random_string` (private)

Generate a random alphanumeric string

> Synopsis:
> `_generate_random_string <LENGTH>`
- `LENGTH`: _(type: "int")_ The length of the generated string.

- ⚠️ Requires: `cut`, `od`, `printf`, `tr`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 207. `_sanitize` (private)

Sanitize string for safe eval

> Synopsis:
> `_sanitize <STRING>`
- `STRING`: _(type: "str")_ The string to sanitize.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 208. `_trim` (private)

Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string

> Synopsis:
> `_trim <STRING>`
- `STRING`: _(type: "str")_ The string to trim.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 209. `_url_decode` (private)

Decode a string from URL format

> Synopsis:
> `_url_decode <STRING>`
- `STRING`: _(type: "str")_ The URL-encoded string to decode.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 210. `_url_encode` (private)

Encode a string to URL format

> Synopsis:
> `_url_encode <STRING>`
- `STRING`: _(type: "str")_ The string to URL-encode.

- ⚠️ Requires: `awk`, `od`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 211. `_composer_install` (private)

Install project dependencies with composer

> Synopsis:
> `_composer_install`

- ⚠️ Requires: `composer`, `install`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`, `src/shell/system/_pwd.sh`

#### ⌨️ 212. `_composer_update` (private)

Update project dependencies with composer

> Synopsis:
> `_composer_update`

- ⚠️ Requires: `composer`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 213. `_console` (private)

Get correct Symfony console binary path

> Synopsis:
> `_console`

- ⚠️ Requires: `echo`, `symfony`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 214. `_db_create` (private)

Create Symfony database with Doctrine

> Synopsis:
> `_db_create [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `true`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/symfony/_console.sh`

#### ⌨️ 215. `_db_drop` (private)

Drop database with Doctrine

> Synopsis:
> `_db_drop [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `true`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/symfony/_console.sh`

#### ⌨️ 216. `_db_query` (private)

Executes arbitrary SQL directly from the command line

> Synopsis:
> `_db_query [SQL]`
- `SQL`: _(type: "str")_ (optional) SQL query. _Constraint: `/.+/`._

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/symfony/_console.sh`

#### ⌨️ 217. `_db_schema` (private)

Create schema with Doctrine

> Synopsis:
> `_db_schema [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `true`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/symfony/_console.sh`

#### ⌨️ 218. `_phpunit` (private)

Get correct PHPUnit binary path

> Synopsis:
> `_phpunit`

- ⚠️ Requires: `basename`, `echo`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 219. `_sf_cache` (private)

Clear Symfony cache

> Synopsis:
> `_sf_cache [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `clear`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/symfony/_console.sh`

#### ⌨️ 220. `_sf_lint` (private)

Run linter (sniff)

> Synopsis:
> `_sf_lint`

- ⚠️ Requires: `composer`, `find`, `php`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/symfony/_console.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 221. `_sf_security` (private)

Check security issues in project dependencies (symfony-cli)

> Synopsis:
> `_sf_security`

- ⚠️ Requires: `composer`, `symfony`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_is_installed.sh`

#### ⌨️ 222. `_sf_serve` (private)

Run a local web server with Symfony CLI

> Synopsis:
> `_sf_serve`

- ⚠️ Requires: `symfony`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 223. `_sf_test` (private)

Run test with PHPUnit

> Synopsis:
> `_sf_test [FILE_PATH]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the input file.

- ⚠️ Requires: `php`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/symfony/_phpunit.sh`

#### ⌨️ 224. `_check_installed` (private)

Print error message if provided command is missing

> Synopsis:
> `_check_installed <COMMAND>`
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/system/_get_package_name.sh`, `src/shell/system/_is_installed.sh`

#### ⌨️ 225. `_get_package_name` (private)

Find package name for given command

> Synopsis:
> `_get_package_name <COMMAND>`
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `echo`, `snap`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 226. `_get_web_user` (private)

Print the user running the web server

> Synopsis:
> `_get_web_user`

- ⚠️ Requires: `awk`, `comm`, `command`, `grep`, `head`, `printf`, `ps`, `true`

#### ⌨️ 227. `_is_checksum_valid` (private)

Validate a file checksum

> Synopsis:
> `_is_checksum_valid <FILE_PATH> <SHA256SUM>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `SHA256SUM`: _(type: "str")_ A string containing file checksum.

- ⚠️ Requires: `awk`, `printf`, `realpath`, `sha256sum`, `tr`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 228. `_is_installed` (private)

Check provided command is installed

> Synopsis:
> `_is_installed <COMMAND>`
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `dpkg`, `grep`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 229. `_is_root` (private)

Check current user is root

> Synopsis:
> `_is_root`

- ⚠️ Requires: `awk`, `id`

#### ⌨️ 230. `_own` (private)

Change the owner of a file or folder

> Synopsis:
> `_own <SOURCE> [-u VALUE] [-g VALUE] [-n] [-r] [-R] [-s]`
- `SOURCE`: _(type: "path")_ The file or folder to update.
- `-u`: _(type: "str")_ The owner user name. _Defaults to "current user"._
- `-g`: _(type: "str")_ The owner group name. _Defaults to "owner user"._
- `-n`: Set the owner to nobody:nogroup.
- `-r`: Change the owner recursively.
- `-R`: Set the owner to root.
- `-s`: Execute chown with sudo.

- ⚠️ Requires: `awk`, `chown`, `printf`, `realpath`, `sudo`, `whoami`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 231. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally

> Synopsis:
> `_pwd`

- ⚠️ Requires: `dirname`, `pwd`, `realpath`

#### ⌨️ 232. `_remove` (private)

Remove given package from system

> Synopsis:
> `_remove <PACKAGE> [PACKAGE_MANAGER]`
- `PACKAGE`: _(type: "str")_ The command/package to remove.
- `PACKAGE_MANAGER`: _(type: "str")_ (optional) The package manager required to remove the package with. _Defaults to "apt"._

- ⚠️ Requires: `apt`, `apt-get`, `snap`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/compatibility/_package_manager.sh`, `src/shell/system/_get_package_name.sh`, `src/shell/system/_is_installed.sh`

#### ⌨️ 233. `_require` (private)

Install required package globally

> Synopsis:
> `_require <PACKAGE> [PACKAGE_MANAGER]`
- `PACKAGE`: _(type: "str")_ The command/package to remove.
- `PACKAGE_MANAGER`: _(type: "str")_ (optional) The package manager required to remove the package with. _Defaults to "apt"._

- ⚠️ Requires: `apt`, `apt-get`, `install`, `snap`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/compatibility/_package_manager.sh`, `src/shell/system/_get_package_name.sh`, `src/shell/system/_is_installed.sh`

#### ⌨️ 234. `_set_web_permissions` (private)

Grant the web server user read and write access to a folder

> Synopsis:
> `_set_web_permissions <DIRECTORY> [-u VALUE]`
- `DIRECTORY`: _(type: "folder")_ The folder to grant access to.
- `-u`: _(type: "str")_ The web server user. _Defaults to "_get_web_user"._

- ⚠️ Requires: `awk`, `command`, `printf`, `realpath`, `setfacl`

- 🔗 Depends: `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`, `src/shell/system/_get_web_user.sh`

#### ⌨️ 235. `_spin` (private)

Animate a spinner in the terminal for a given amout of time

> Synopsis:
> `_spin [DURATION]`
- `DURATION`: _(type: "int")_ (optional) Animation duration in miliseconds. _Defaults to "0"._

- ⚠️ Requires: `awk`, `printf`, `sleep`

#### ⌨️ 236. `_user_exists` (private)

Check provided user exists

> Synopsis:
> `_user_exists <USERNAME>`
- `USERNAME`: _(type: "str")_ The username to check.

- ⚠️ Requires: `id`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 237. `_check_duplicate_functions` (private)

Exit with an error when a script defines a function more than once

> Synopsis:
> `_check_duplicate_functions <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the script to inspect.

- ⚠️ Requires: `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/reflexion/_get_functions_names.sh`

#### ⌨️ 238. `_is_valid` (private)

Checks if variable is valid given regex constraint

> Synopsis:
> `_is_valid <VALUE> <PATTERN>`
- `VALUE`: _(type: "str")_ The string to be compared to regex pattern.
- `PATTERN`: _(type: "str")_ The regex parttern to apply.

- ⚠️ Requires: `awk`, `printf`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 239. `_validate` (private)

Find constraints and validates a variable

> Synopsis:
> `_validate <VARIABLE> [CONSTRAINT]`
- `VARIABLE`: _(type: "str")_ The variable to validate in the followling format : variable_name=value.
- `CONSTRAINT`: _(type: "str")_ (optional) Optional constraint, read from the script when omitted.

- ⚠️ Requires: `cut`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/reflexion/_get_constraint.sh`, `src/shell/validation/_is_valid.sh`

#### ⌨️ 240. `_validate_alias` (private)

Reject an alias that cannot be used as a single path component

> Synopsis:
> `_validate_alias <ALIAS> <FUNCTION_NAME>`
- `ALIAS`: _(type: "str")_ The alias to validate.
- `FUNCTION_NAME`: _(type: "str")_ The caller, used in the message.

- 🔗 Depends: `src/shell/colors/_echo_error.sh`

#### ⌨️ 241. `_validate_positionals` (private)

Bind positional parameters to the variables named in a function shoedoc

> Synopsis:
> `_validate_positionals <SCRIPT_PATH> <FUNCTION_NAME> [POSITIONAL]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The command being executed.
- `POSITIONAL`: _(type: "str")_ (optional) The positional values to bind.

- ⚠️ Requires: `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/reflexion/_get_function_parameters.sh`, `src/shell/validation/_validate.sh`

#### ⌨️ 242. `_kernel` (private)

Shoe Kernel

> Synopsis:
> `_kernel`

- ⚠️ Requires: `printf`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/help/_help.sh`, `src/shell/hooks/_after.sh`, `src/shell/hooks/_before.sh`, `src/shell/hooks/_default.sh`, `src/shell/reflexion/_get_constraint.sh`, `src/shell/reflexion/_get_flags.sh`, `src/shell/reflexion/_get_function_parameters.sh`, `src/shell/reflexion/_get_functions_names.sh`, `src/shell/reflexion/_get_options.sh`, `src/shell/validation/_check_duplicate_functions.sh`, `src/shell/validation/_validate.sh`, `src/shell/validation/_validate_positionals.sh`
