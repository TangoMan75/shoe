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

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 2. `_adb_sideload` (private)

Sideload given full OTA package to connected device

> Synopsis:
> `_adb_sideload <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `adb`, `realpath`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 3. `_adb_start_server` (private)

Start local adb server

> Synopsis:
> `_adb_start_server`

- ⚠️ Requires: `adb`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 4. `_fastboot_lock` (private)

Lock bootloader and flashing

> Synopsis:
> `_fastboot_lock`

- ⚠️ Requires: `fastboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 5. `_fastboot_unlock` (private)

Unlock bootloader and flashing

> Synopsis:
> `_fastboot_unlock`

- ⚠️ Requires: `fastboot`, `true`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 6. `_fastboot_wipe` (private)

Wipe userdata on connected device

> Synopsis:
> `_fastboot_wipe`

- ⚠️ Requires: `fastboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 7. `_flash_img` (private)

Flash img file to connected device provided partition

> Synopsis:
> `_flash_img <FILE_PATH> <PARTITION> [FORCE]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PARTITION`: _(type: "str")_ The name of the target partition.
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

- ⚠️ Requires: `fastboot`, `realpath`, `true`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 8. `_get_apk_label` (private)

Get APK label

> Synopsis:
> `_get_apk_label <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `aapt`, `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 9. `_get_apk_package_name` (private)

Get APK package_name

> Synopsis:
> `_get_apk_package_name <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `aapt`, `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 10. `_get_apk_path` (private)

Get installed APK path on connected device from package name

> Synopsis:
> `_get_apk_path <PACKAGE_NAME>`
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"

- ⚠️ Requires: `adb`, `awk`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb`, `src/shell/colors/_echo_error`

#### ⌨️ 11. `_get_apk_version` (private)

Get APK version

> Synopsis:
> `_get_apk_version <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `aapt`, `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 12. `_install_apk` (private)

Install APK on connected device

> Synopsis:
> `_install_apk <FILE_PATH> [FORCE]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

- ⚠️ Requires: `adb`, `install`, `realpath`, `true`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 13. `_is_apk_installed` (private)

Check if package is installed on connected device

> Synopsis:
> `_is_apk_installed <PACKAGE_NAME>`
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"

- ⚠️ Requires: `adb`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb`, `src/shell/colors/_echo_error`

#### ⌨️ 14. `_is_device_connected_with_adb` (private)

Check device is connected with adb

> Synopsis:
> `_is_device_connected_with_adb`

- ⚠️ Requires: `adb`, `tail`

- 🔗 Depends: `src/shell/system/_check_installed`

#### ⌨️ 15. `_is_device_connected_with_fastboot` (private)

Check device is connected with fastboot

> Synopsis:
> `_is_device_connected_with_fastboot`

- ⚠️ Requires: `fastboot`

- 🔗 Depends: `src/shell/system/_check_installed`

#### ⌨️ 16. `_list_installed_apks` (private)

List installed packages on connected device

> Synopsis:
> `_list_installed_apks`

- ⚠️ Requires: `adb`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb`, `src/shell/colors/_echo_error`

#### ⌨️ 17. `_pull_apk` (private)

Copy APK from connected device to local folder

> Synopsis:
> `_pull_apk <PACKAGE_NAME> <DESTINATION>`
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.

- ⚠️ Requires: `adb`, `realpath`

- 🔗 Depends: `src/shell/android/_get_apk_path`, `src/shell/android/_is_device_connected_with_adb`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 18. `_reboot_bootloader` (private)

Reboot connected device to bootloader

> Synopsis:
> `_reboot_bootloader`

- ⚠️ Requires: `adb`, `fastboot`, `reboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb`, `src/shell/android/_is_device_connected_with_fastboot`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 19. `_reboot_recovery` (private)

Reboot connected device to recovery

> Synopsis:
> `_reboot_recovery`

- ⚠️ Requires: `adb`, `fastboot`, `reboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb`, `src/shell/android/_is_device_connected_with_fastboot`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 20. `_reboot_system` (private)

Reboot connected device to system

> Synopsis:
> `_reboot_system`

- ⚠️ Requires: `adb`, `fastboot`, `reboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb`, `src/shell/android/_is_device_connected_with_fastboot`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 21. `_reboot_with_img` (private)

Boot connected device with given image temporarily

> Synopsis:
> `_reboot_with_img <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `fastboot`, `realpath`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 22. `_remove_apk` (private)

Remove APK from connected device

> Synopsis:
> `_remove_apk <PACKAGE_NAME> [FORCE]`
- `PACKAGE_NAME`: _(type: "str")_ The apk package name. eg: "org.fdroid.fdroid"
- `FORCE`: _(type: "bool")_ (optional) Force install. _Defaults to "false"._

- ⚠️ Requires: `adb`, `true`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_adb`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 23. `_toggle_active_slot` (private)

Toggle connected device active slot

> Synopsis:
> `_toggle_active_slot`

- ⚠️ Requires: `fastboot`

- 🔗 Depends: `src/shell/android/_is_device_connected_with_fastboot`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

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

- 🔗 Depends: `src/shell/colors/_echo_error`

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

#### ⌨️ 53. `_open` (private)

Return the command that opens a file or URL with the default handler

> Synopsis:
> `_open`

- ⚠️ Requires: `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/compatibility/_os_type`

#### ⌨️ 54. `_os_type` (private)

Print the current operating system type

> Synopsis:
> `_os_type`

- ⚠️ Requires: `printf`, `uname`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 55. `_package_manager` (private)

Print the default package manager for the current operating system

> Synopsis:
> `_package_manager`

- ⚠️ Requires: `apt`, `apt-get`, `command`, `printf`, `snap`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/compatibility/_is_termux`, `src/shell/compatibility/_os_type`

#### ⌨️ 56. `_readlink` (private)

Return the command that resolves a canonical path

> Synopsis:
> `_readlink`

- ⚠️ Requires: `command`, `printf`, `readlink`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 57. `_sed_i` (private)

Return sed -i system flavour

> Synopsis:
> `_sed_i`

- ⚠️ Requires: `command`, `printf`, `sed`, `uname`

#### ⌨️ 58. `_sha256` (private)

Return the command that computes a SHA-256 digest

> Synopsis:
> `_sha256`

- ⚠️ Requires: `command`, `openssl`, `printf`, `sha256sum`, `shasum`

- 🔗 Depends: `src/shell/colors/_echo_error`

### ⚡ SRC/SHELL/DEV

#### ⌨️ 59. `_list_ides` (private)

List installed ides

> Synopsis:
> `_list_ides`

- ⚠️ Requires: `code`, `command`, `nano`, `phpstorm`, `printf`, `subl`, `vim`

### ⚡ SRC/SHELL/DOCKER

#### ⌨️ 60. `_docker_compose` (private)

Return docker compose command

> Synopsis:
> `_docker_compose`

- ⚠️ Requires: `basename`, `command`, `docker`, `docker-compose`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 61. `_docker_compose_build` (private)

Build container stack with docker compose

> Synopsis:
> `_docker_compose_build [FILE_PATH]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/docker/_docker_compose`

#### ⌨️ 62. `_docker_compose_start` (private)

Build and start container stack with docker compose

> Synopsis:
> `_docker_compose_start [FILE_PATH] [ENV_FILE]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.
- `ENV_FILE`: _(type: "file")_ (optional) The path to the env file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/docker/_docker_compose`

#### ⌨️ 63. `_docker_compose_stop` (private)

Stop container stack with docker compose

> Synopsis:
> `_docker_compose_stop [FILE_PATH]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/docker/_docker_compose`

#### ⌨️ 64. `_docker_exec` (private)

Execute command in the given docker container

> Synopsis:
> `_docker_exec <CONTAINER_NAME> <COMMAND> [USER]`
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.
- `COMMAND`: _(type: "str")_ The command to execute.
- `USER`: _(type: "str")_ (optional) The user name.

- ⚠️ Requires: `docker`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 65. `_docker_kill_all` (private)

Kill all running containers with docker

> Synopsis:
> `_docker_kill_all`

- ⚠️ Requires: `docker`, `kill`, `ps`, `tr`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 66. `_docker_rm` (private)

Remove given docker container

> Synopsis:
> `_docker_rm <CONTAINER_NAME>`
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.

- ⚠️ Requires: `docker`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 67. `_docker_run` (private)

Spawn a new container with given image, name, command and volume

> Synopsis:
> `_docker_run <IMAGE> <NAME> <COMMAND> [FOLDER_PATH]`
- `IMAGE`: _(type: "str")_ The name of the container image to run.
- `NAME`: _(type: "str")_ Assign a name to the container.
- `COMMAND`: _(type: "str")_ The command to run inside provided container.
- `FOLDER_PATH`: _(type: "folder")_ (optional) The path to the volume folder.

- ⚠️ Requires: `docker`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 68. `_docker_run_atmoz_sftp` (private)

Run local atmoz_sftp server

> Synopsis:
> `_docker_run_atmoz_sftp <USERNAME> <PASSWORD> [NETWORK_MODE] [FOLDER_PATH]`
- `USERNAME`: _(type: "str")_ The name of the container to run.
- `PASSWORD`: _(type: "str")_ The password for the sftp server access.
- `NETWORK_MODE`: _(type: "str")_ (optional) The user name. _Constraint: `/^(bridge|host)$/`._
- `FOLDER_PATH`: _(type: "folder")_ (optional) The path to the volume folder.

- ⚠️ Requires: `docker`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 69. `_docker_run_whoami` (private)

Run local whoami server

> Synopsis:
> `_docker_run_whoami`

- ⚠️ Requires: `docker`, `whoami`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 70. `_docker_status` (private)

Print docker status

> Synopsis:
> `_docker_status`

- ⚠️ Requires: `column`, `docker`, `ps`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 71. `_find_container_name` (private)

Find container name from string

> Synopsis:
> `_find_container_name <STRING>`
- `STRING`: _(type: "str")_ The string to find among running containers.

- ⚠️ Requires: `docker`, `grep`, `head`, `printf`, `ps`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 72. `_get_container_id` (private)

Get container id from name

> Synopsis:
> `_get_container_id <CONTAINER_NAME> [TRUNCATE]`
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.
- `TRUNCATE`: _(type: "bool")_ (optional) Truncate id to 12 characters long. _Defaults to "true"._

- ⚠️ Requires: `docker`, `false`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 73. `_get_container_ip` (private)

Get running container ip

> Synopsis:
> `_get_container_ip <CONTAINER_NAME|CONTAINER_ID>`
- `CONTAINER_NAME|CONTAINER_ID`: _(type: "str")_ The name or the id of the docker container.

- ⚠️ Requires: `docker`, `printf`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 74. `_get_container_name` (private)

Get container name from id

> Synopsis:
> `_get_container_name <CONTAINER_ID>`
- `CONTAINER_ID`: _(type: "str")_ The container id.

- ⚠️ Requires: `docker`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 75. `_is_container_running` (private)

Checks if given container is running

> Synopsis:
> `_is_container_running <CONTAINER_NAME|CONTAINER_ID>`
- `CONTAINER_NAME|CONTAINER_ID`: _(type: "str")_ The name or the id of the docker container.

- ⚠️ Requires: `docker`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 76. `_wait_for_postgres` (private)

Wait for postgresql container to start with docker

> Synopsis:
> `_wait_for_postgres <CONTAINER_NAME> [USERNAME]`
- `CONTAINER_NAME`: _(type: "str")_ The name of the docker container.
- `USERNAME`: _(type: "str")_ (optional) The psql username. _Defaults to ""._

- ⚠️ Requires: `docker`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/system/_check_installed`, `src/shell/system/_spin`

#### ⌨️ 77. `_wait_for_rabbit` (private)

Wait for rabbitmq container to start with docker

> Synopsis:
> `_wait_for_rabbit <CONTAINER_NAME>`
- `CONTAINER_NAME`: _(type: "str")_ The name of the docker container.

- ⚠️ Requires: `docker`, `grep`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/system/_check_installed`, `src/shell/system/_spin`

### ⚡ Documentation

#### ⌨️ 78. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script

> Synopsis:
> `_generate_doc <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", documents private constants, options, flags, and commands as well. _Defaults to "false"._

- ⚠️ Requires: `awk`, `basename`, `dirname`, `grep`, `printf`, `realpath`, `sed`

- 🔗 Depends: `src/shell/colors/_alert_primary`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_success`, `src/shell/reflexion/_get_functions_names`, `src/shell/reflexion/_print_synopsis`, `src/shell/shoedoc/_get_function_shoedoc`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_description`, `src/shell/shoedoc/_get_shoedoc_tag`, `src/shell/shoedoc/_get_shoedoc_title`

#### ⌨️ 79. `generate_doc` (public)

Generate Markdown documentation for current shoe script

> Synopsis:
> `generate_doc`

- 🔗 Depends: `src/shell/documentation/_generate_doc`

#### ⌨️ 80. `_create_env` (private)

Create a ".env" file when missing

> Synopsis:
> `_create_env <FILE_PATH> [TEMPLATE]`
- `FILE_PATH`: _(type: "file")_ The path of the ".env" file to create.
- `TEMPLATE`: _(type: "file")_ (optional) Optional template file to copy into the new file.

- ⚠️ Requires: `cp`, `dirname`, `mkdir`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 81. `_load_dotenv` (private)

Load the first dotenv file found for an environment

> Synopsis:
> `_load_dotenv <ENV> [DIRECTORY]`
- `ENV`: _(type: "str")_ The application environment name.
- `DIRECTORY`: _(type: "folder")_ (optional) The folder containing the dotenv files. _Defaults to "."._

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/env/_load_env`

#### ⌨️ 82. `_load_env` (private)

Load environment variables from a ".env" file

> Synopsis:
> `_load_env <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path of the ".env" file to load.

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 83. `_change_extension` (private)

Change the extension of a file

> Synopsis:
> `_change_extension <SOURCE> <EXTENSION>`
- `SOURCE`: _(type: "file")_ The file to rename.
- `EXTENSION`: _(type: "str")_ The extension to apply. _Constraint: `/^\.[a-zA-Z0-9]+$/`._

- ⚠️ Requires: `basename`, `dirname`, `mv`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 84. `_clean_folder` (private)

Recursively delete common junk files and folders

> Synopsis:
> `_clean_folder <SOURCE>`
- `SOURCE`: _(type: "folder")_ The folder to clean.

- ⚠️ Requires: `find`, `realpath`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 85. `_compress` (private)

Compress a file or folder into an archive

> Synopsis:
> `_compress <SOURCE> [DESTINATION] [-r]`
- `SOURCE`: _(type: "path")_ The file or folder to compress.
- `DESTINATION`: _(type: "folder")_ (optional) The folder receiving the archives. _Defaults to "current folder"._
- `-r`: Create one archive per direct subfolder.

- ⚠️ Requires: `basename`, `command`, `dirname`, `find`, `grep`, `printf`, `realpath`, `sed`, `sort`, `tar`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 86. `_extract` (private)

Extract file based on its extension

> Synopsis:
> `_extract <FILE_PATH> [DESTINATION]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.

- ⚠️ Requires: `dirname`, `realpath`, `tar`, `unzip`, `zip`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 87. `_get_file_extension` (private)

Get file extension

> Synopsis:
> `_get_file_extension <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 88. `_get_size` (private)

Print the human readable size of a file or folder

> Synopsis:
> `_get_size <SOURCE>`
- `SOURCE`: _(type: "path")_ The file or folder to measure.

- ⚠️ Requires: `du`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 89. `_move` (private)

Move file or folder to destination (creates folder when missing)

> Synopsis:
> `_move <SOURCE> <DESTINATION>`
- `SOURCE`: _(type: "path")_ The path to the input file or folder.
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.

- ⚠️ Requires: `cp`, `mkdir`, `mv`, `realpath`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 90. `_blob_exists` (private)

Check if a git blob exists in the repository

> Synopsis:
> `_blob_exists <BLOB_HASH> [-v]`
- `BLOB_HASH`: _(type: "str")_ The git blob hash to check.
- `-v`: Print the command before execution.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 91. `_branch_exists` (private)

Check if a git branch exists in the local or remote repository

> Synopsis:
> `_branch_exists <BRANCH> [-a] [-r] [-v]`
- `BRANCH`: _(type: "str")_ The branch name to check.
- `-a`: Search all references.
- `-r`: Search remote branches only.
- `-v`: Print the command before execution.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 92. `_check_branch_is_valid` (private)

Check if a git branch name is valid

> Synopsis:
> `_check_branch_is_valid <BRANCH>`
- `BRANCH`: _(type: "str")_ The branch name to validate.

- ⚠️ Requires: `printf`, `tr`

#### ⌨️ 93. `_check_commit_is_valid` (private)

Check if a commit hash is valid

> Synopsis:
> `_check_commit_is_valid <COMMIT>`
- `COMMIT`: _(type: "str")_ The commit hash to validate.

- ⚠️ Requires: `grep`, `printf`, `tr`

#### ⌨️ 94. `_commit_exists` (private)

Check if a git commit exists in the repository

> Synopsis:
> `_commit_exists <COMMIT_HASH> [-v]`
- `COMMIT_HASH`: _(type: "str")_ The commit hash to check.
- `-v`: Print the command before execution.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 95. `_format_branch_subject` (private)

Format a branch subject

> Synopsis:
> `_format_branch_subject <SUBJECT>`
- `SUBJECT`: _(type: "str")_ The branch subject to format.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 96. `_format_commit_subject` (private)

Format a commit subject

> Synopsis:
> `_format_commit_subject <SUBJECT>`
- `SUBJECT`: _(type: "str")_ The commit subject to format.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 97. `_format_ticket` (private)

Format a ticket identifier

> Synopsis:
> `_format_ticket <TICKET>`
- `TICKET`: _(type: "str")_ The ticket identifier to format.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 98. `_format_type` (private)

Format a conventional commit type

> Synopsis:
> `_format_type <TYPE>`
- `TYPE`: _(type: "str")_ The commit type to format.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 99. `_get_branch_subject` (private)

Get branch subject

> Synopsis:
> `_get_branch_subject`

- ⚠️ Requires: `HEAD`, `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/git/_parse_branch_subject`

#### ⌨️ 100. `_get_branch_ticket` (private)

Get branch ticket

> Synopsis:
> `_get_branch_ticket`

- ⚠️ Requires: `HEAD`, `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/git/_parse_branch_ticket`

#### ⌨️ 101. `_get_branch_type` (private)

Get branch type

> Synopsis:
> `_get_branch_type`

- ⚠️ Requires: `HEAD`, `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/git/_parse_branch_type`

#### ⌨️ 102. `_get_commit_body` (private)

Get commit body

> Synopsis:
> `_get_commit_body`

- ⚠️ Requires: `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/strings/_trim`

#### ⌨️ 103. `_get_commit_pull_request` (private)

Get commit pull request

> Synopsis:
> `_get_commit_pull_request`

- ⚠️ Requires: `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/git/_parse_commit_pull_request`

#### ⌨️ 104. `_get_commit_scope` (private)

Get commit scope

> Synopsis:
> `_get_commit_scope`

- ⚠️ Requires: `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/git/_parse_commit_scope`

#### ⌨️ 105. `_get_commit_subject` (private)

Get commit subject

> Synopsis:
> `_get_commit_subject`

- ⚠️ Requires: `command`, `git`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/git/_parse_commit_subject`

#### ⌨️ 106. `_get_commit_ticket` (private)

Get commit ticket id

> Synopsis:
> `_get_commit_ticket`

- ⚠️ Requires: `command`, `git`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/git/_get_branch_ticket`, `src/shell/git/_parse_commit_ticket`

#### ⌨️ 107. `_get_commit_type` (private)

Get commit type

> Synopsis:
> `_get_commit_type`

- ⚠️ Requires: `command`, `git`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/git/_get_branch_type`, `src/shell/git/_parse_commit_type`

#### ⌨️ 108. `_get_current_branch` (private)

Get the current git branch name

> Synopsis:
> `_get_current_branch [-v]`
- `-v`: Print the command before execution.

- ⚠️ Requires: `HEAD`, `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 109. `_get_git_remote_url` (private)

Print the web URL of a git remote

> Synopsis:
> `_get_git_remote_url [REMOTE]`
- `REMOTE`: _(type: "str")_ (optional) The name of the git remote. _Defaults to "origin"._

- ⚠️ Requires: `git`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 110. `_get_latest_release` (private)

Get repository latest release version from github

> Synopsis:
> `_get_latest_release <REPOSITORY>`
- `REPOSITORY`: _(type: "str")_ Owner and repository name in the form: owner/repository.

- ⚠️ Requires: `command`, `curl`, `grep`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 111. `_get_main_branch` (private)

Get main branch name

> Synopsis:
> `_get_main_branch [-v]`
- `-v`: Print the git command before executing it.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 112. `_git_hooks` (private)

Update .git/hooks folder

> Synopsis:
> `_git_hooks <SOURCE>`
- `SOURCE`: _(type: "folder")_ The source directory.

- ⚠️ Requires: `chmod`, `cp`, `git`, `realpath`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 113. `_initialise_submodules` (private)

Initialise git submodules

> Synopsis:
> `_initialise_submodules`

- ⚠️ Requires: `git`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 114. `_is_cherry_pick_in_progress` (private)

Check if a git cherry-pick is in progress

> Synopsis:
> `_is_cherry_pick_in_progress [-v]`
- `-v`: Print the test command before executing it.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 115. `_is_rebase_in_progress` (private)

Check if a git rebase is in progress

> Synopsis:
> `_is_rebase_in_progress [-v]`
- `-v`: Print the test command before executing it.

- ⚠️ Requires: `command`, `git`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 116. `_list_github` (private)

Lists user's GitHub repositories

> Synopsis:
> `_list_github <OWNER> [-v]`
- `OWNER`: _(type: "str")_ GitHub owner name.
- `-v`: Print command before execution.

- ⚠️ Requires: `command`, `curl`, `grep`, `jq`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 117. `_parse_branch_subject` (private)

Parse branch subject

> Synopsis:
> `_parse_branch_subject <BRANCH>`
- `BRANCH`: _(type: "str")_ The conventional branch name to parse.

- ⚠️ Requires: `grep`, `printf`

#### ⌨️ 118. `_parse_branch_ticket` (private)

Parse branch ticket

> Synopsis:
> `_parse_branch_ticket <BRANCH>`
- `BRANCH`: _(type: "str")_ The conventional branch name to parse.

- ⚠️ Requires: `printf`, `sed`

#### ⌨️ 119. `_parse_branch_type` (private)

Parse branch type

> Synopsis:
> `_parse_branch_type <BRANCH>`
- `BRANCH`: _(type: "str")_ The conventional branch name to parse.

- ⚠️ Requires: `printf`

#### ⌨️ 120. `_parse_commit_pull_request` (private)

Parse commit pull request number

> Synopsis:
> `_parse_commit_pull_request <COMMIT_MESSAGE>`
- `COMMIT_MESSAGE`: _(type: "str")_ The conventional commit message to parse.

- ⚠️ Requires: `printf`, `sed`

#### ⌨️ 121. `_parse_commit_scope` (private)

Parse commit scope

> Synopsis:
> `_parse_commit_scope <COMMIT_MESSAGE>`
- `COMMIT_MESSAGE`: _(type: "str")_ The conventional commit message to parse.

- ⚠️ Requires: `awk`, `command`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`

#### ⌨️ 122. `_parse_commit_subject` (private)

Parse commit subject

> Synopsis:
> `_parse_commit_subject <COMMIT_MESSAGE>`
- `COMMIT_MESSAGE`: _(type: "str")_ The conventional commit message to parse.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 123. `_parse_commit_ticket` (private)

Parse commit ticket

> Synopsis:
> `_parse_commit_ticket <COMMIT_MESSAGE>`
- `COMMIT_MESSAGE`: _(type: "str")_ The conventional commit message to parse.

- ⚠️ Requires: `printf`, `sed`

#### ⌨️ 124. `_parse_commit_type` (private)

Parse commit type

> Synopsis:
> `_parse_commit_type <COMMIT_MESSAGE>`
- `COMMIT_MESSAGE`: _(type: "str")_ The conventional commit message to parse.

- ⚠️ Requires: `awk`, `printf`

#### ⌨️ 125. `_pick_branch` (private)

Select a branch interactively from a list of git branches

> Synopsis:
> `_pick_branch [-F VALUE] [-a] [-c] [-m] [-v]`
- `-F`: _(type: "str")_ Grep filter applied to the branch list.
- `-a`: List all branches.
- `-c`: Include the current branch.
- `-m`: Include the main branch.
- `-v`: Print the command before execution.

- ⚠️ Requires: `HEAD`, `awk`, `command`, `git`, `grep`, `mktemp`, `printf`, `rm`, `sed`, `true`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/git/_get_main_branch`

#### ⌨️ 126. `_pick_commit` (private)

Select a commit interactively from a list of git commits

> Synopsis:
> `_pick_commit [BRANCH] [-n VALUE] [-v]`
- `BRANCH`: _(type: "str")_ (optional) The branch to list commits from.
- `-n`: _(type: "int")_ The number of commits to list. _Defaults to "16"._
- `-v`: Print the command before execution.

- ⚠️ Requires: `awk`, `command`, `cut`, `git`, `grep`, `head`, `mktemp`, `printf`, `rm`, `sed`, `true`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 127. `_pick_repository` (private)

Select a repository interactively from a GitHub user's repositories

> Synopsis:
> `_pick_repository <OWNER>`
- `OWNER`: _(type: "str")_ The GitHub user name.

- ⚠️ Requires: `awk`, `grep`, `mktemp`, `printf`, `rm`, `sed`, `true`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/git/_list_github`

#### ⌨️ 128. `_print_jira_url` (private)

Print Jira URL

> Synopsis:
> `_print_jira_url <TICKET>`
- `TICKET`: _(type: "str")_ The Jira ticket identifier (e.g., FOO-123).

- ⚠️ Requires: `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 129. `_deploy` (private)

Deploy source folder to "gh-pages"

> Synopsis:
> `_deploy <SOURCE>`
- `SOURCE`: _(type: "folder")_ The source directory.

- ⚠️ Requires: `HEAD`, `git`, `split`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

### ⚡ Help

#### ⌨️ 130. `_help` (private)

Print help for a shoe script or one of its commands

> Synopsis:
> `_help <FILE_PATH> [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `COMMAND_NAME`: _(type: "str")_ (optional) The command name to get detailed help for.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_alert_primary`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/help/_print_command_details`, `src/shell/help/_print_commands`, `src/shell/help/_print_constants`, `src/shell/help/_print_description`, `src/shell/help/_print_flags`, `src/shell/help/_print_infos`, `src/shell/help/_print_options`, `src/shell/help/_print_usage`, `src/shell/reflexion/_get_constants`, `src/shell/reflexion/_get_flags`, `src/shell/reflexion/_get_options`, `src/shell/reflexion/_get_padding`, `src/shell/shoedoc/_get_function_shoedoc`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_description`, `src/shell/shoedoc/_get_shoedoc_title`

#### ⌨️ 131. `help` (public)

Print this help

> Synopsis:
> `help [COMMAND_NAME]`
- `COMMAND_NAME`: _(type: "str")_ (optional) The command name to print detailed help for.

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/help/_help`

#### ⌨️ 132. `_print_command_details` (private)

Print detailed help for a given command

> Synopsis:
> `_print_command_details <FILE_PATH> <COMMAND_NAME> <ANNOTATIONS>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `COMMAND_NAME`: _(type: "str")_ The command name to document.
- `ANNOTATIONS`: _(type: "str")_ The shoedoc annotation block, classic @-tags.

- ⚠️ Requires: `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_warning`, `src/shell/help/_print_description`, `src/shell/help/_print_flags`, `src/shell/help/_print_options`, `src/shell/help/_print_usage`, `src/shell/reflexion/_get_padding`, `src/shell/shoedoc/_get_shoedoc_description`, `src/shell/shoedoc/_get_shoedoc_tag`, `src/shell/shoedoc/_get_shoedoc_title`

#### ⌨️ 133. `_print_commands` (private)

List commands of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_commands <FILE_PATH> [PADDING]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_warning`

#### ⌨️ 134. `_print_constants` (private)

List constants of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_constants <FILE_PATH> [PADDING]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_warning`

#### ⌨️ 135. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)

> Synopsis:
> `_print_description <DESCRIPTION>`
- `DESCRIPTION`: _(type: "str")_ A string containing script description.

- ⚠️ Requires: `fold`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_warning`

#### ⌨️ 136. `_print_flags` (private)

List flags of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_flags <FILE_PATH> [PADDING] [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._
- `COMMAND_NAME`: _(type: "str")_ (optional) Optional command whose flags should be added.

- ⚠️ Requires: `awk`, `grep`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/reflexion/_get_flags`, `src/shell/reflexion/_get_function_parameters`

#### ⌨️ 137. `_print_infos` (private)

Print infos of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_infos <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_tag`

#### ⌨️ 138. `_print_options` (private)

List options of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_options <FILE_PATH> [PADDING] [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._
- `COMMAND_NAME`: _(type: "str")_ (optional) Optional command whose options should be added.

- ⚠️ Requires: `awk`, `grep`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/reflexion/_get_function_parameters`, `src/shell/reflexion/_get_options`

#### ⌨️ 139. `_print_usage` (private)

Print usage of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_usage <FILE_PATH> [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `COMMAND_NAME`: _(type: "str")_ (optional) Optional command whose parameters should be added.

- ⚠️ Requires: `awk`, `basename`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/reflexion/_get_flags`, `src/shell/reflexion/_get_function_parameters`, `src/shell/reflexion/_get_options`

#### ⌨️ 140. `_after` (private)

Place here commands you need executed last every time (optional)

> Synopsis:
> `_after`

#### ⌨️ 141. `_before` (private)

Place here commands you need executed first every time (optional)

> Synopsis:
> `_before`

- ⚠️ Requires: `awk`, `sed`

- 🔗 Depends: `src/shell/system/_check_installed`

#### ⌨️ 142. `_default` (private)

Place here commands you need executed by default (optional)

> Synopsis:
> `_default`

- 🔗 Depends: `src/shell/help/help`

### ⚡ Self Install

#### ⌨️ 143. `_copy_install` (private)

Install script via copy

> Synopsis:
> `_copy_install <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `cp`, `realpath`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 144. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file

> Synopsis:
> `_generate_autocomplete <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `dirname`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/install/_get_comspec`

#### ⌨️ 145. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file

> Synopsis:
> `_generate_global_autocomplete <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `printf`, `realpath`, `sudo`, `tee`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/install/_get_comspec`

#### ⌨️ 146. `_get_comspec` (private)

Generate comspec string for the provided file

> Synopsis:
> `_get_comspec <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 147. `_install` (private)

Install script and enable autocompletion

> Synopsis:
> `_install <FILE_PATH> [ALIAS] [GLOBAL]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

- ⚠️ Requires: `basename`, `bash`, `realpath`, `touch`, `true`, `uname`, `zsh`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/install/_copy_install`, `src/shell/install/_generate_autocomplete`, `src/shell/install/_generate_global_autocomplete`, `src/shell/install/_set_completion_autoload`, `src/shell/install/_symlink_install`, `src/shell/system/_is_installed`

#### ⌨️ 148. `_remove_completion_autoload` (private)

Remove completion script autoload

> Synopsis:
> `_remove_completion_autoload <SHELL_CONFIG_FILE> [ALIAS]`
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`

#### ⌨️ 149. `self_install` (public)

Install script and enable autocompletion

> Synopsis:
> `self_install`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_install`

#### ⌨️ 150. `self_uninstall` (public)

Uninstall script from system

> Synopsis:
> `self_uninstall`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_uninstall`

#### ⌨️ 151. `self_update` (public)

Update script from @update

> Synopsis:
> `self_update`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/install/_update`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_tag`

#### ⌨️ 152. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file

> Synopsis:
> `_set_completion_autoload <SHELL_CONFIG_FILE> <SCRIPT_FILE_PATH> [ALIAS]`
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `SCRIPT_FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `dirname`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`, `src/shell/strings/_collapse_blank_lines`

#### ⌨️ 153. `_symlink_install` (private)

Install script via symlink

> Synopsis:
> `_symlink_install <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `ln`, `realpath`, `sudo`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 154. `_uninstall` (private)

Uninstall script from system

> Synopsis:
> `_uninstall <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `dirname`, `realpath`, `rm`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/install/_remove_completion_autoload`

#### ⌨️ 155. `_update` (private)

Updates given script from the provided URL

> Synopsis:
> `_update <FILE_PATH> <URL> [ALIAS] [GLOBAL]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `URL`: _(type: "str")_ The URL of the script to download and install.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

- ⚠️ Requires: `basename`, `curl`, `realpath`, `wget`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/install/_install`, `src/shell/install/_uninstall`, `src/shell/system/_is_installed`

### ⚡ Make

#### ⌨️ 156. `_generate_makefile` (private)

Generate Makefile for provided shoe script

> Synopsis:
> `_generate_makefile <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

- ⚠️ Requires: `awk`, `basename`, `cat`, `dirname`, `grep`, `printf`, `realpath`, `tr`

- 🔗 Depends: `src/shell/colors/_alert_primary`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_success`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_description`, `src/shell/shoedoc/_get_shoedoc_tag`, `src/shell/shoedoc/_get_shoedoc_title`

#### ⌨️ 157. `generate_makefile` (public)

Generate Makefile for current shoe script

> Synopsis:
> `generate_makefile`

- 🔗 Depends: `src/shell/make/_generate_makefile`

#### ⌨️ 158. `_check_dns` (private)

Print the DNS records of a domain

> Synopsis:
> `_check_dns <DOMAIN> [-t VALUE]`
- `DOMAIN`: _(type: "str")_ The domain to check.
- `-t`: _(type: "str")_ The DNS record type to query. _Defaults to "A"._

- ⚠️ Requires: `awk`, `command`, `dig`, `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 159. `_download` (private)

Downloads file with either curl or wget

> Synopsis:
> `_download <URL> <FILE_PATH>`
- `URL`: _(type: "str")_ The URL of the file to download.
- `FILE_PATH`: _(type: "file")_ The path to the output file.

- ⚠️ Requires: `curl`, `dirname`, `grep`, `head`, `mkdir`, `wget`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_is_installed`

#### ⌨️ 160. `_get_external_ip` (private)

Print the external IPv4 address of the current connection

> Synopsis:
> `_get_external_ip`

- ⚠️ Requires: `command`, `curl`, `printf`, `wget`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 161. `_list_adapters` (private)

List the network adapters available on the system

> Synopsis:
> `_list_adapters [-c] [-w] [-v]`
- `-c`: Only list adapters with a connected peer.
- `-w`: Only list wireless adapters.
- `-v`: Print the command before execution.

- ⚠️ Requires: `arp`, `command`, `cut`, `grep`, `ifconfig`, `ip`, `iwconfig`, `printf`, `sed`, `sort`, `tr`, `true`, `uniq`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 162. `_open_in_default_browser` (private)

Open in default browser

> Synopsis:
> `_open_in_default_browser [IP] [PORT] [SCHEME]`
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Constraint: `/^[0-9]{1,5}$/`._ _Defaults to "8080"._
- `SCHEME`: _(type: "str")_ (optional) scheme - e.g. http. _Defaults to "http"._

- ⚠️ Requires: `nohup`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_open`

#### ⌨️ 163. `_php_serve` (private)

Serve given local directory with PHP

> Synopsis:
> `_php_serve <DOCROOT> [IP] [PORT]`
- `DOCROOT`: _(type: "folder")_ The path to the root directory.
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Constraint: `/^[0-9]{1,5}$/`._ _Defaults to "8080"._

- ⚠️ Requires: `php`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 164. `_py_serve` (private)

Serve given local directory with Python 3

> Synopsis:
> `_py_serve <DOCROOT> [IP] [PORT]`
- `DOCROOT`: _(type: "folder")_ The path to the root directory.
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Constraint: `/^[0-9]{1,5}$/`._ _Defaults to "8080"._

- ⚠️ Requires: `python3`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 165. `_remove_host` (private)

Remove hostname from /etc/hosts

> Synopsis:
> `_remove_host <HOSTNAME>`
- `HOSTNAME`: _(type: "str")_ The hostame to unset locally.

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`

#### ⌨️ 166. `_set_host` (private)

Set new host in /etc/hosts

> Synopsis:
> `_set_host <HOSTNAME>`
- `HOSTNAME`: _(type: "str")_ The hostame to set locally.

- ⚠️ Requires: `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/network/_remove_host`

#### ⌨️ 167. `_npm_build` (private)

Build app to destination folder

> Synopsis:
> `_npm_build <DESTINATION>`
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.

- ⚠️ Requires: `npm`, `realpath`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 168. `_npm_lint` (private)

Lint source files

> Synopsis:
> `_npm_lint`

- ⚠️ Requires: `npm`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 169. `_npm_test` (private)

Run tests

> Synopsis:
> `_npm_test`

- ⚠️ Requires: `npm`, `test`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 170. `_npm_watch` (private)

Watch source folder for changes

> Synopsis:
> `_npm_watch`

- ⚠️ Requires: `npm`, `watch`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 171. `_select` (private)

Present user with a list of choices and prompt them to select one

> Synopsis:
> `_select <CHOICES>`
- `CHOICES`: _(type: "str")_ Array containing choices.

- ⚠️ Requires: `cut`, `echo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 172. `_yes_no` (private)

Promt user for yes or no

> Synopsis:
> `_yes_no [QUESTION]`
- `QUESTION`: _(type: "str")_ (optional) A string containing the question. _Defaults to "Confirm ?"._

- ⚠️ Requires: `echo`, `grep`

- 🔗 Depends: `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 173. `_get_constants` (private)

List constants from provided shoe script

> Synopsis:
> `_get_constants <SCRIPT_PATH> [GET_PRIVATE]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private constants as well. _Defaults to "false"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 174. `_get_constraint` (private)

Get constaint for given variable from provided shoe script

> Synopsis:
> `_get_constraint <SCRIPT_PATH> <VARIABLE_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `VARIABLE_NAME`: _(type: "str")_ The variable to validate.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 175. `_get_flags` (private)

List flags from provided shoe script

> Synopsis:
> `_get_flags <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 176. `_get_function` (private)

Get function by name

> Synopsis:
> `_get_function <SCRIPT_PATH> <FUNCTION_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 177. `_get_function_parameters` (private)

List options and flags declared in a function shoedoc annotation

> Synopsis:
> `_get_function_parameters <SCRIPT_PATH> <FUNCTION_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to inspect.

- ⚠️ Requires: `awk`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/shoedoc/_get_function_shoedoc`

#### ⌨️ 178. `_get_functions_names` (private)

List functions names from provided shoe script

> Synopsis:
> `_get_functions_names <SCRIPT_PATH> [GET_PRIVATE]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private functions as well. _Defaults to "false"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 179. `_get_options` (private)

List options from provided shoe script

> Synopsis:
> `_get_options <SCRIPT_PATH> [GET_PRIVATE_ONLY]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE_ONLY`: _(type: "bool")_ (optional) If set to "true", retrieves private options only. _Defaults to "false"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 180. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script

> Synopsis:
> `_get_padding <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 181. `_get_parameter` (private)

Get value for given parameter from provided ".env" or ".sh" file

> Synopsis:
> `_get_parameter <FILE_PATH> <KEY>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.

- ⚠️ Requires: `realpath`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 182. `_has_parameter` (private)

Tests if parameter exists in provided ".env" or ".sh" file

> Synopsis:
> `_has_parameter <FILE_PATH> <KEY>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.

- ⚠️ Requires: `grep`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 183. `_print_synopsis` (private)

Print function synopsis from shoedoc annotations

> Synopsis:
> `_print_synopsis <FUNCTION_NAME> <ANNOTATIONS> [MARKDOWN_FORMAT]`
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to document.
- `ANNOTATIONS`: _(type: "str")_ The shoedoc annotation block, classic @-tags.
- `MARKDOWN_FORMAT`: _(type: "bool")_ (optional) If set to "true", returns result as markdown. _Defaults to "false"._

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 184. `_set_parameter` (private)

Set a variable in a ".env" or ".sh" file

> Synopsis:
> `_set_parameter <FILE_PATH> <KEY> <VALUE> [FORCE]`
- `FILE_PATH`: _(type: "file")_ The ".env" file to update.
- `KEY`: _(type: "str")_ The variable name to set.
- `VALUE`: _(type: "str")_ The value to assign.
- `FORCE`: _(type: "bool")_ (optional) Append the variable when missing. _Defaults to "false"._

- ⚠️ Requires: `awk`, `cat`, `grep`, `mktemp`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 185. `_get_function_shoedoc` (private)

Get function shedoc annotation by name

> Synopsis:
> `_get_function_shoedoc <SCRIPT_PATH> <FUNCTION_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 186. `_get_script_shoedoc` (private)

Get top-level shoedoc annotation of the provided shoe script file

> Synopsis:
> `_get_script_shoedoc <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 187. `_get_shoedoc` (private)

Get shoedoc annotation

> Synopsis:
> `_get_shoedoc <TEXT>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 188. `_get_shoedoc_description` (private)

Get shoedoc description

> Synopsis:
> `_get_shoedoc_description <TEXT>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 189. `_get_shoedoc_tag` (private)

Return given tag values from shoedoc annotation

> Synopsis:
> `_get_shoedoc_tag <TEXT> <TAG_NAME>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.
- `TAG_NAME`: _(type: "str")_ The name of tag to return.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 190. `_get_shoedoc_title` (private)

Get shoedoc title

> Synopsis:
> `_get_shoedoc_title <TEXT>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 191. `_config_ssh_file_permissions` (private)

Set the expected permissions on the ~/.ssh folder

> Synopsis:
> `_config_ssh_file_permissions`

- ⚠️ Requires: `chmod`, `chown`, `find`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 192. `_is_gcr_ssh_agent` (private)

Check if the current ssh agent is gcr-ssh-agent

> Synopsis:
> `_is_gcr_ssh_agent`

#### ⌨️ 193. `_is_ssh_agent_running` (private)

Check if an ssh agent is running

> Synopsis:
> `_is_ssh_agent_running [SOCKET]`
- `SOCKET`: _(type: "str")_ (optional) The ssh agent socket path. _Defaults to "$SSH_AUTH_SOCK"._

- ⚠️ Requires: `ssh-add`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 194. `_list_ssh_identities` (private)

List the identities loaded in the ssh agent

> Synopsis:
> `_list_ssh_identities`

- ⚠️ Requires: `command`, `ssh-add`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 195. `_ssh_add_all_identities` (private)

Add every ssh identity found in ~/.ssh to the ssh agent

> Synopsis:
> `_ssh_add_all_identities`

- ⚠️ Requires: `command`, `find`, `printf`, `sed`, `ssh-add`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_warning`

#### ⌨️ 196. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"

> Synopsis:
> `_collapse_blank_lines <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`

#### ⌨️ 197. `_decode_base64` (private)

Decode a base64 string

> Synopsis:
> `_decode_base64 <STRING>`
- `STRING`: _(type: "str")_ The base64 string to decode.

- ⚠️ Requires: `base64`, `command`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 198. `_dedupe_lines` (private)

Remove every line in target file that contains substrings from source file

> Synopsis:
> `_dedupe_lines <SOURCE_PATH> <TARGET_PATH>`
- `SOURCE_PATH`: _(type: "file")_ The path to the file containing the substrings to remove.
- `TARGET_PATH`: _(type: "file")_ The path to the target file to deduplicate.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`

#### ⌨️ 199. `_encode_base64` (private)

Encode a string to base64

> Synopsis:
> `_encode_base64 <STRING>`
- `STRING`: _(type: "str")_ The string to encode.

- ⚠️ Requires: `base64`, `command`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 200. `_generate_key` (private)

Generate random 32 bit string

> Synopsis:
> `_generate_key`

- ⚠️ Requires: `openssl`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 201. `_generate_random_string` (private)

Generate a random alphanumeric string

> Synopsis:
> `_generate_random_string <LENGTH>`
- `LENGTH`: _(type: "int")_ The length of the generated string.

- ⚠️ Requires: `cut`, `od`, `printf`, `tr`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 202. `_sanitize` (private)

Sanitize string for safe eval

> Synopsis:
> `_sanitize <STRING>`
- `STRING`: _(type: "str")_ The string to sanitize.

- ⚠️ Requires: `printf`, `sed`

#### ⌨️ 203. `_trim` (private)

Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string

> Synopsis:
> `_trim <STRING>`
- `STRING`: _(type: "str")_ The string to trim.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 204. `_url_decode` (private)

Decode a string from URL format

> Synopsis:
> `_url_decode <STRING>`
- `STRING`: _(type: "str")_ The URL-encoded string to decode.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 205. `_url_encode` (private)

Encode a string to URL format

> Synopsis:
> `_url_encode <STRING>`
- `STRING`: _(type: "str")_ The string to URL-encode.

- ⚠️ Requires: `awk`, `od`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 206. `_composer_install` (private)

Install project dependencies with composer

> Synopsis:
> `_composer_install`

- ⚠️ Requires: `composer`, `install`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`, `src/shell/system/_pwd`

#### ⌨️ 207. `_composer_update` (private)

Update project dependencies with composer

> Synopsis:
> `_composer_update`

- ⚠️ Requires: `composer`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 208. `_console` (private)

Get correct Symfony console binary path

> Synopsis:
> `_console`

- ⚠️ Requires: `basename`, `echo`, `symfony`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 209. `_db_create` (private)

Create Symfony database with Doctrine

> Synopsis:
> `_db_create [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_console`

#### ⌨️ 210. `_db_drop` (private)

Drop database with Doctrine

> Synopsis:
> `_db_drop [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_console`

#### ⌨️ 211. `_db_query` (private)

Executes arbitrary SQL directly from the command line

> Synopsis:
> `_db_query [SQL]`
- `SQL`: _(type: "str")_ (optional) SQL query. _Constraint: `/.+/`._

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_console`

#### ⌨️ 212. `_db_schema` (private)

Create schema with Doctrine

> Synopsis:
> `_db_schema [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_console`

#### ⌨️ 213. `_phpunit` (private)

Get correct PHPUnit binary path

> Synopsis:
> `_phpunit`

- ⚠️ Requires: `basename`, `echo`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 214. `_sf_cache` (private)

Clear Symfony cache

> Synopsis:
> `_sf_cache [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `clear`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_console`

#### ⌨️ 215. `_sf_lint` (private)

Run linter (sniff)

> Synopsis:
> `_sf_lint`

- ⚠️ Requires: `composer`, `find`, `php`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/symfony/_console`, `src/shell/system/_check_installed`

#### ⌨️ 216. `_sf_security` (private)

Check security issues in project dependencies (symfony-cli)

> Synopsis:
> `_sf_security`

- ⚠️ Requires: `composer`, `symfony`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_is_installed`

#### ⌨️ 217. `_sf_serve` (private)

Run a local web server with Symfony CLI

> Synopsis:
> `_sf_serve`

- ⚠️ Requires: `symfony`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 218. `_sf_test` (private)

Run test with PHPUnit

> Synopsis:
> `_sf_test [FILE_PATH]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the input file.

- ⚠️ Requires: `php`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_phpunit`

#### ⌨️ 219. `_check_installed` (private)

Print error message if provided command is missing

> Synopsis:
> `_check_installed <COMMAND>`
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_get_package_name`, `src/shell/system/_is_installed`

#### ⌨️ 220. `_get_package_name` (private)

Find package name for given command

> Synopsis:
> `_get_package_name <COMMAND>`
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `echo`, `snap`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 221. `_get_web_user` (private)

Print the user running the web server

> Synopsis:
> `_get_web_user`

- ⚠️ Requires: `awk`, `comm`, `command`, `grep`, `head`, `printf`, `ps`, `true`

#### ⌨️ 222. `_is_checksum_valid` (private)

Validate a file checksum

> Synopsis:
> `_is_checksum_valid <FILE_PATH> <SHA256SUM>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `SHA256SUM`: _(type: "str")_ A string containing file checksum.

- ⚠️ Requires: `awk`, `grep`, `realpath`, `set`, `sha256sum`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 223. `_is_installed` (private)

Check provided command is installed

> Synopsis:
> `_is_installed <COMMAND>`
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `dpkg`, `grep`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 224. `_is_root` (private)

Check current user is root

> Synopsis:
> `_is_root`

- ⚠️ Requires: `awk`, `id`

#### ⌨️ 225. `_own` (private)

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

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 226. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally

> Synopsis:
> `_pwd`

- ⚠️ Requires: `dirname`, `pwd`, `realpath`

#### ⌨️ 227. `_remove` (private)

Remove given package from system

> Synopsis:
> `_remove <PACKAGE> [PACKAGE_MANAGER]`
- `PACKAGE`: _(type: "str")_ The command/package to remove.
- `PACKAGE_MANAGER`: _(type: "str")_ (optional) The package manager required to remove the package with. _Defaults to "apt"._

- ⚠️ Requires: `apt`, `apt-get`, `snap`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_package_manager`, `src/shell/system/_get_package_name`, `src/shell/system/_is_installed`

#### ⌨️ 228. `_require` (private)

Install required package globally

> Synopsis:
> `_require <PACKAGE> [PACKAGE_MANAGER]`
- `PACKAGE`: _(type: "str")_ The command/package to remove.
- `PACKAGE_MANAGER`: _(type: "str")_ (optional) The package manager required to remove the package with. _Defaults to "apt"._

- ⚠️ Requires: `apt`, `apt-get`, `install`, `snap`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_package_manager`, `src/shell/system/_get_package_name`, `src/shell/system/_is_installed`

#### ⌨️ 229. `_set_web_permissions` (private)

Grant the web server user read and write access to a folder

> Synopsis:
> `_set_web_permissions <DIRECTORY> [-u VALUE]`
- `DIRECTORY`: _(type: "folder")_ The folder to grant access to.
- `-u`: _(type: "str")_ The web server user. _Defaults to "_get_web_user"._

- ⚠️ Requires: `awk`, `command`, `printf`, `realpath`, `setfacl`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/system/_get_web_user`

#### ⌨️ 230. `_spin` (private)

Animate a spinner in the terminal for a given amout of time

> Synopsis:
> `_spin [DURATION]`
- `DURATION`: _(type: "int")_ (optional) Animation duration in miliseconds. _Defaults to "0"._

- ⚠️ Requires: `awk`, `printf`, `sleep`

#### ⌨️ 231. `_user_exists` (private)

Check provided user exists

> Synopsis:
> `_user_exists <USERNAME>`
- `USERNAME`: _(type: "str")_ The username to check.

- ⚠️ Requires: `id`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 232. `_check_duplicate_functions` (private)

Exit with an error when a script defines a function more than once

> Synopsis:
> `_check_duplicate_functions <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the script to inspect.

- ⚠️ Requires: `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/reflexion/_get_functions_names`

#### ⌨️ 233. `_is_valid` (private)

Checks if variable is valid given regex constraint

> Synopsis:
> `_is_valid <VALUE> <PATTERN>`
- `VALUE`: _(type: "str")_ The string to be compared to regex pattern.
- `PATTERN`: _(type: "str")_ The regex parttern to apply.

- ⚠️ Requires: `grep`, `printf`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 234. `_validate` (private)

Find constraints and validates a variable

> Synopsis:
> `_validate <VARIABLE> [CONSTRAINT]`
- `VARIABLE`: _(type: "str")_ The variable to validate in the followling format : variable_name=value.
- `CONSTRAINT`: _(type: "str")_ (optional) Optional constraint, read from the script when omitted.

- ⚠️ Requires: `cut`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/reflexion/_get_constraint`, `src/shell/validation/_is_valid`

#### ⌨️ 235. `_light_kernel` (private)

Shoe Light Kernel

> Synopsis:
> `_light_kernel`

- ⚠️ Requires: `printf`

- 🔗 Depends: `src/shell/hooks/_default`, `src/shell/reflexion/_get_functions_names`, `src/shell/validation/_check_duplicate_functions`
