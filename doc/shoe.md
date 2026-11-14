# shoe

## ℹ️ Infos


## 📑 Description



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

#### ⌨️ 28. `_alert_primary` (private)

Print primary alert

> Synopsis:
> `_alert_primary <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 29. `_alert_secondary` (private)

Print secondary alert

> Synopsis:
> `_alert_secondary <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 30. `_alert_success` (private)

Print success alert

> Synopsis:
> `_alert_success <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 31. `_alert_warning` (private)

Print warning alert

> Synopsis:
> `_alert_warning <STRING>`
- `STRING`: _(type: "str")_ Text to display.

- ⚠️ Requires: `printf`

#### ⌨️ 32. `_echo_danger` (private)

Print danger text with optional indentation and padding

> Synopsis:
> `_echo_danger <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 33. `_echo_dark` (private)

Print dark text with optional indentation and padding

> Synopsis:
> `_echo_dark <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 34. `_echo_error` (private)

Print error message to STDERR, prefixed with "error: "

> Synopsis:
> `_echo_error <MESSAGE>`
- `MESSAGE`: _(type: "str")_ Error message to display.

- ⚠️ Requires: `printf`

#### ⌨️ 35. `_echo_info` (private)

Print info text with optional indentation and padding

> Synopsis:
> `_echo_info <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 36. `_echo_light` (private)

Print light text with optional indentation and padding

> Synopsis:
> `_echo_light <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 37. `_echo_primary` (private)

Print primary text with optional indentation and padding

> Synopsis:
> `_echo_primary <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 38. `_echo_secondary` (private)

Print secondary text with optional indentation and padding

> Synopsis:
> `_echo_secondary <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 39. `_echo_success` (private)

Print success text with optional indentation and padding

> Synopsis:
> `_echo_success <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

#### ⌨️ 40. `_echo_warning` (private)

Print warning text with optional indentation and padding

> Synopsis:
> `_echo_warning <STRING> [INDENTATION] [PADDING]`
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

- ⚠️ Requires: `printf`

### ⚡ SRC/SHELL/COMPATIBILITY

#### ⌨️ 41. `_clipboard` (private)

Return the command that copies stdin to the system clipboard

> Synopsis:
> `_clipboard`

- ⚠️ Requires: `command`, `printf`, `wl-copy`, `xclip`, `xsel`

#### ⌨️ 42. `_is_android` (private)

Check current system is Android

> Synopsis:
> `_is_android`

- ⚠️ Requires: `uname`

#### ⌨️ 43. `_is_bsd` (private)

Check current system is BSD

> Synopsis:
> `_is_bsd`

- ⚠️ Requires: `uname`

#### ⌨️ 44. `_is_cygwin` (private)

Check current system is Cygwin

> Synopsis:
> `_is_cygwin`

- ⚠️ Requires: `uname`

#### ⌨️ 45. `_is_darwin` (private)

Check current system is Darwin

> Synopsis:
> `_is_darwin`

- ⚠️ Requires: `uname`

#### ⌨️ 46. `_is_gnome` (private)

Check current desktop is gnome

> Synopsis:
> `_is_gnome`

#### ⌨️ 47. `_is_linux` (private)

Check current system is Linux

> Synopsis:
> `_is_linux`

- ⚠️ Requires: `uname`

#### ⌨️ 48. `_is_msys` (private)

Check current system is MSYS or MINGW

> Synopsis:
> `_is_msys`

- ⚠️ Requires: `uname`

#### ⌨️ 49. `_is_termux` (private)

Check current environment is Termux

> Synopsis:
> `_is_termux`

#### ⌨️ 50. `_is_wsl` (private)

Check current system is Windows Subsystem for Linux

> Synopsis:
> `_is_wsl`

- ⚠️ Requires: `grep`

#### ⌨️ 51. `_open` (private)

Return the command that opens a file or URL with the default handler

> Synopsis:
> `_open`

- ⚠️ Requires: `printf`

- 🔗 Depends: `src/shell/compatibility/_os_type`

#### ⌨️ 52. `_os_type` (private)

Print the current operating system type

> Synopsis:
> `_os_type`

- ⚠️ Requires: `printf`, `uname`

#### ⌨️ 53. `_package_manager` (private)

Print the default package manager for the current operating system

> Synopsis:
> `_package_manager`

- ⚠️ Requires: `apt`, `apt-get`, `command`, `printf`, `snap`

- 🔗 Depends: `src/shell/compatibility/_is_termux`, `src/shell/compatibility/_os_type`

#### ⌨️ 54. `_readlink` (private)

Return the command that resolves a canonical path

> Synopsis:
> `_readlink`

- ⚠️ Requires: `command`, `printf`, `readlink`, `realpath`

#### ⌨️ 55. `_sed_i` (private)

Return sed -i system flavour

> Synopsis:
> `_sed_i`

- ⚠️ Requires: `command`, `printf`, `sed`, `uname`

#### ⌨️ 56. `_sha256` (private)

Return the command that computes a SHA-256 digest

> Synopsis:
> `_sha256`

- ⚠️ Requires: `command`, `openssl`, `printf`, `sha256sum`, `shasum`

### ⚡ SRC/SHELL/DOCKER

#### ⌨️ 57. `_docker_compose_build` (private)

Build container stack with docker compose

> Synopsis:
> `_docker_compose_build [FILE_PATH]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/docker/_get_docker_compose`

#### ⌨️ 58. `_docker_compose_start` (private)

Build and start container stack with docker compose

> Synopsis:
> `_docker_compose_start [FILE_PATH] [ENV_FILE]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.
- `ENV_FILE`: _(type: "file")_ (optional) The path to the env file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/docker/_get_docker_compose`

#### ⌨️ 59. `_docker_compose_stop` (private)

Stop container stack with docker compose

> Synopsis:
> `_docker_compose_stop [FILE_PATH]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the compose.yaml file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/docker/_get_docker_compose`

#### ⌨️ 60. `_docker_exec` (private)

Execute command in the given docker container

> Synopsis:
> `_docker_exec <CONTAINER_NAME> <COMMAND> [USER]`
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.
- `COMMAND`: _(type: "str")_ The command to execute.
- `USER`: _(type: "str")_ (optional) The user name.

- ⚠️ Requires: `docker`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 61. `_docker_kill_all` (private)

Kill all running containers with docker

> Synopsis:
> `_docker_kill_all`

- ⚠️ Requires: `docker`, `kill`, `ps`, `tr`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 62. `_docker_rm` (private)

Remove given docker container

> Synopsis:
> `_docker_rm <CONTAINER_NAME>`
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.

- ⚠️ Requires: `docker`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 63. `_docker_run` (private)

Spawn a new container with given image, name, command and volume

> Synopsis:
> `_docker_run <IMAGE> <NAME> <COMMAND> [FOLDER_PATH]`
- `IMAGE`: _(type: "str")_ The name of the container image to run.
- `NAME`: _(type: "str")_ Assign a name to the container.
- `COMMAND`: _(type: "str")_ The command to run inside provided container.
- `FOLDER_PATH`: _(type: "folder")_ (optional) The path to the volume folder.

- ⚠️ Requires: `docker`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 64. `_docker_run_atmoz_sftp` (private)

Run local atmoz_sftp server

> Synopsis:
> `_docker_run_atmoz_sftp <USERNAME> <PASSWORD> [NETWORK_MODE] [FOLDER_PATH]`
- `USERNAME`: _(type: "str")_ The name of the container to run.
- `PASSWORD`: _(type: "str")_ The password for the sftp server access.
- `NETWORK_MODE`: _(type: "str")_ (optional) The user name. _Constraint: `/^(bridge|host)$/`._
- `FOLDER_PATH`: _(type: "folder")_ (optional) The path to the volume folder.

- ⚠️ Requires: `docker`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 65. `_docker_run_whoami` (private)

Run local whoami server

> Synopsis:
> `_docker_run_whoami`

- ⚠️ Requires: `docker`, `whoami`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 66. `_docker_status` (private)

Print docker status

> Synopsis:
> `_docker_status`

- ⚠️ Requires: `column`, `docker`, `ps`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 67. `_find_container_name` (private)

Find container name from string

> Synopsis:
> `_find_container_name <STRING>`
- `STRING`: _(type: "str")_ The string to find among running containers.

- ⚠️ Requires: `docker`, `grep`, `head`, `printf`, `ps`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 68. `_get_container_id` (private)

Get container id from name

> Synopsis:
> `_get_container_id <CONTAINER_NAME> [TRUNCATE]`
- `CONTAINER_NAME`: _(type: "str")_ The name of the container to run.
- `TRUNCATE`: _(type: "bool")_ (optional) Truncate id to 12 characters long. _Defaults to "true"._

- ⚠️ Requires: `docker`, `false`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 69. `_get_container_ip` (private)

Get running container ip

> Synopsis:
> `_get_container_ip <CONTAINER_NAME|CONTAINER_ID>`
- `CONTAINER_NAME|CONTAINER_ID`: _(type: "str")_ The name or the id of the docker container.

- ⚠️ Requires: `docker`, `printf`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 70. `_get_container_name` (private)

Get container name from id

> Synopsis:
> `_get_container_name <CONTAINER_ID>`
- `CONTAINER_ID`: _(type: "str")_ The container id.

- ⚠️ Requires: `docker`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 71. `_get_docker_compose` (private)

Return docker compose command

> Synopsis:
> `_get_docker_compose`

- ⚠️ Requires: `basename`, `command`, `docker`, `docker-compose`, `echo`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 72. `_is_container_running` (private)

Checks if given container is running

> Synopsis:
> `_is_container_running <CONTAINER_NAME|CONTAINER_ID>`
- `CONTAINER_NAME|CONTAINER_ID`: _(type: "str")_ The name or the id of the docker container.

- ⚠️ Requires: `docker`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 73. `_wait_for_postgres` (private)

Wait for postgresql container to start with docker

> Synopsis:
> `_wait_for_postgres <CONTAINER_NAME> [USERNAME]`
- `CONTAINER_NAME`: _(type: "str")_ The name of the docker container.
- `USERNAME`: _(type: "str")_ (optional) The psql username. _Defaults to ""._

- ⚠️ Requires: `docker`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/system/_check_installed`, `src/shell/system/_spin`

#### ⌨️ 74. `_wait_for_rabbit` (private)

Wait for rabbitmq container to start with docker

> Synopsis:
> `_wait_for_rabbit <CONTAINER_NAME>`
- `CONTAINER_NAME`: _(type: "str")_ The name of the docker container.

- ⚠️ Requires: `docker`, `grep`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/system/_check_installed`, `src/shell/system/_spin`

### ⚡ Documentation

#### ⌨️ 75. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script

> Synopsis:
> `_generate_doc <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", documents private constants, options, flags, and commands as well. _Defaults to "false"._

- ⚠️ Requires: `awk`, `basename`, `dirname`, `grep`, `printf`, `realpath`, `sed`

- 🔗 Depends: `src/shell/colors/_alert_primary`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_success`, `src/shell/reflexion/_get_functions_names`, `src/shell/reflexion/_print_synopsis`, `src/shell/shoedoc/_get_function_shoedoc`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_description`, `src/shell/shoedoc/_get_shoedoc_tag`, `src/shell/shoedoc/_get_shoedoc_title`

#### ⌨️ 76. `generate_doc` (public)

Generate Markdown documentation for current shoe script

> Synopsis:
> `generate_doc`

- 🔗 Depends: `src/shell/documentation/_generate_doc`

#### ⌨️ 77. `_extract` (private)

Extract file based on its extension

> Synopsis:
> `_extract <FILE_PATH> [DESTINATION]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.

- ⚠️ Requires: `dirname`, `realpath`, `tar`, `unzip`, `zip`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 78. `_get_file_extension` (private)

Get file extension

> Synopsis:
> `_get_file_extension <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `grep`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 79. `_move` (private)

Move file or folder to destination (creates folder when missing)

> Synopsis:
> `_move <SOURCE> <DESTINATION>`
- `SOURCE`: _(type: "path")_ The path to the input file or folder.
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.

- ⚠️ Requires: `cp`, `mkdir`, `mv`, `realpath`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 80. `_git_hooks` (private)

Update .git/hooks folder

> Synopsis:
> `_git_hooks <SOURCE>`
- `SOURCE`: _(type: "folder")_ The source directory.

- ⚠️ Requires: `chmod`, `cp`, `git`, `realpath`, `rm`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 81. `_initialise_submodules` (private)

Initialise git submodules

> Synopsis:
> `_initialise_submodules`

- ⚠️ Requires: `git`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 82. `_deploy` (private)

Deploy source folder to "gh-pages"

> Synopsis:
> `_deploy <SOURCE>`
- `SOURCE`: _(type: "folder")_ The source directory.

- ⚠️ Requires: `HEAD`, `git`, `split`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

### ⚡ Help

#### ⌨️ 83. `_help` (private)

Print help for a shoe script or one of its commands

> Synopsis:
> `_help <FILE_PATH> [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `COMMAND_NAME`: _(type: "str")_ (optional) The command name to get detailed help for.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_alert_primary`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/help/_print_command_details`, `src/shell/help/_print_commands`, `src/shell/help/_print_constants`, `src/shell/help/_print_description`, `src/shell/help/_print_flags`, `src/shell/help/_print_infos`, `src/shell/help/_print_options`, `src/shell/help/_print_usage`, `src/shell/reflexion/_get_constants`, `src/shell/reflexion/_get_flags`, `src/shell/reflexion/_get_options`, `src/shell/reflexion/_get_padding`, `src/shell/shoedoc/_get_function_shoedoc`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_description`, `src/shell/shoedoc/_get_shoedoc_title`

#### ⌨️ 84. `help` (public)

Print this help

> Synopsis:
> `help [COMMAND_NAME]`
- `COMMAND_NAME`: _(type: "str")_ (optional) The command name to print detailed help for.

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/help/_help`

#### ⌨️ 85. `_print_command_details` (private)

Print detailed help for a given command

> Synopsis:
> `_print_command_details <FILE_PATH> <COMMAND_NAME> <ANNOTATIONS>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `COMMAND_NAME`: _(type: "str")_ The command name to document.
- `ANNOTATIONS`: _(type: "str")_ The shoedoc annotation block, classic @-tags.

- ⚠️ Requires: `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_warning`, `src/shell/help/_print_description`, `src/shell/help/_print_flags`, `src/shell/help/_print_options`, `src/shell/help/_print_usage`, `src/shell/reflexion/_get_padding`, `src/shell/shoedoc/_get_shoedoc_description`, `src/shell/shoedoc/_get_shoedoc_tag`, `src/shell/shoedoc/_get_shoedoc_title`

#### ⌨️ 86. `_print_commands` (private)

List commands of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_commands <FILE_PATH> [PADDING]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_warning`

#### ⌨️ 87. `_print_constants` (private)

List constants of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_constants <FILE_PATH> [PADDING]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_warning`

#### ⌨️ 88. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)

> Synopsis:
> `_print_description <DESCRIPTION>`
- `DESCRIPTION`: _(type: "str")_ A string containing script description.

- ⚠️ Requires: `fold`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_warning`

#### ⌨️ 89. `_print_flags` (private)

List flags of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_flags <FILE_PATH> [PADDING] [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._
- `COMMAND_NAME`: _(type: "str")_ (optional) Optional command whose flags should be added.

- ⚠️ Requires: `awk`, `grep`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/reflexion/_get_flags`, `src/shell/reflexion/_get_function_parameters`

#### ⌨️ 90. `_print_infos` (private)

Print infos of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_infos <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_tag`

#### ⌨️ 91. `_print_options` (private)

List options of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_options <FILE_PATH> [PADDING] [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._
- `COMMAND_NAME`: _(type: "str")_ (optional) Optional command whose options should be added.

- ⚠️ Requires: `awk`, `grep`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_primary`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/reflexion/_get_function_parameters`, `src/shell/reflexion/_get_options`

#### ⌨️ 92. `_print_usage` (private)

Print usage of the provided shoe script (used by "help" command)

> Synopsis:
> `_print_usage <FILE_PATH> [COMMAND_NAME]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `COMMAND_NAME`: _(type: "str")_ (optional) Optional command whose parameters should be added.

- ⚠️ Requires: `awk`, `basename`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`, `src/shell/reflexion/_get_flags`, `src/shell/reflexion/_get_function_parameters`, `src/shell/reflexion/_get_options`

#### ⌨️ 93. `_after` (private)

Place here commands you need executed last every time (optional)

> Synopsis:
> `_after`

#### ⌨️ 94. `_before` (private)

Place here commands you need executed first every time (optional)

> Synopsis:
> `_before`

- ⚠️ Requires: `awk`, `sed`

- 🔗 Depends: `src/shell/system/_check_installed`

#### ⌨️ 95. `_default` (private)

Place here commands you need executed by default (optional)

> Synopsis:
> `_default`

- 🔗 Depends: `src/shell/help/help`

### ⚡ Self Install

#### ⌨️ 96. `_copy_install` (private)

Install script via copy

> Synopsis:
> `_copy_install <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `cp`, `realpath`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 97. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file

> Synopsis:
> `_generate_autocomplete <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `dirname`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/install/_get_comspec`

#### ⌨️ 98. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file

> Synopsis:
> `_generate_global_autocomplete <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `printf`, `realpath`, `sudo`, `tee`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/install/_get_comspec`

#### ⌨️ 99. `_get_comspec` (private)

Generate comspec string for the provided file

> Synopsis:
> `_get_comspec <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 100. `_install` (private)

Install script and enable autocompletion

> Synopsis:
> `_install <FILE_PATH> [ALIAS] [GLOBAL]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

- ⚠️ Requires: `basename`, `bash`, `realpath`, `touch`, `true`, `uname`, `zsh`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/install/_copy_install`, `src/shell/install/_generate_autocomplete`, `src/shell/install/_generate_global_autocomplete`, `src/shell/install/_set_completion_autoload`, `src/shell/install/_symlink_install`, `src/shell/system/_is_installed`

#### ⌨️ 101. `_remove_completion_autoload` (private)

Remove completion script autoload

> Synopsis:
> `_remove_completion_autoload <SHELL_CONFIG_FILE> [ALIAS]`
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`

#### ⌨️ 102. `self_install` (public)

Install script and enable autocompletion

> Synopsis:
> `self_install`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_install`

#### ⌨️ 103. `self_uninstall` (public)

Uninstall script from system

> Synopsis:
> `self_uninstall`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_uninstall`

#### ⌨️ 104. `self_update` (public)

Update script from @update

> Synopsis:
> `self_update`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/install/_update`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_tag`

#### ⌨️ 105. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file

> Synopsis:
> `_set_completion_autoload <SHELL_CONFIG_FILE> <SCRIPT_FILE_PATH> [ALIAS]`
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `SCRIPT_FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `dirname`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`, `src/shell/strings/_collapse_blank_lines`

#### ⌨️ 106. `_symlink_install` (private)

Install script via symlink

> Synopsis:
> `_symlink_install <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `ln`, `realpath`, `sudo`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 107. `_uninstall` (private)

Uninstall script from system

> Synopsis:
> `_uninstall <FILE_PATH> [ALIAS]`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- ⚠️ Requires: `basename`, `dirname`, `realpath`, `rm`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/install/_remove_completion_autoload`

#### ⌨️ 108. `_update` (private)

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

#### ⌨️ 109. `_generate_makefile` (private)

Generate Makefile for provided shoe script

> Synopsis:
> `_generate_makefile <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

- ⚠️ Requires: `awk`, `basename`, `cat`, `dirname`, `grep`, `printf`, `realpath`, `tr`

- 🔗 Depends: `src/shell/colors/_alert_primary`, `src/shell/colors/_echo_error`, `src/shell/colors/_echo_success`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_description`, `src/shell/shoedoc/_get_shoedoc_tag`, `src/shell/shoedoc/_get_shoedoc_title`

#### ⌨️ 110. `generate_makefile` (public)

Generate Makefile for current shoe script

> Synopsis:
> `generate_makefile`

- 🔗 Depends: `src/shell/make/_generate_makefile`

#### ⌨️ 111. `_download` (private)

Downloads file with either curl or wget

> Synopsis:
> `_download <URL> <FILE_PATH>`
- `URL`: _(type: "str")_ The URL of the file to download.
- `FILE_PATH`: _(type: "file")_ The path to the output file.

- ⚠️ Requires: `curl`, `dirname`, `grep`, `head`, `mkdir`, `wget`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_is_installed`

#### ⌨️ 112. `_open_in_default_browser` (private)

Open in default browser

> Synopsis:
> `_open_in_default_browser [IP] [PORT] [SCHEME]`
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Constraint: `/^[0-9]{1,5}$/`._ _Defaults to "8080"._
- `SCHEME`: _(type: "str")_ (optional) scheme - e.g. http. _Defaults to "http"._

- ⚠️ Requires: `nohup`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_open`

#### ⌨️ 113. `_php_serve` (private)

Serve given local directory with PHP

> Synopsis:
> `_php_serve <DOCROOT> [IP] [PORT]`
- `DOCROOT`: _(type: "folder")_ The path to the root directory.
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Constraint: `/^[0-9]{1,5}$/`._ _Defaults to "8080"._

- ⚠️ Requires: `php`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 114. `_py_serve` (private)

Serve given local directory with Python 3

> Synopsis:
> `_py_serve <DOCROOT> [IP] [PORT]`
- `DOCROOT`: _(type: "folder")_ The path to the root directory.
- `IP`: _(type: "str")_ (optional) Target IP address or domain. _Defaults to "127.0.0.1"._
- `PORT`: _(type: "int")_ (optional) Destination port. _Constraint: `/^[0-9]{1,5}$/`._ _Defaults to "8080"._

- ⚠️ Requires: `python3`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 115. `_remove_host` (private)

Remove hostname from /etc/hosts

> Synopsis:
> `_remove_host <HOSTNAME>`
- `HOSTNAME`: _(type: "str")_ The hostame to unset locally.

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`

#### ⌨️ 116. `_set_host` (private)

Set new host in /etc/hosts

> Synopsis:
> `_set_host <HOSTNAME>`
- `HOSTNAME`: _(type: "str")_ The hostame to set locally.

- ⚠️ Requires: `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/network/_remove_host`

#### ⌨️ 117. `_select` (private)

Present user with a list of choices and prompt them to select one

> Synopsis:
> `_select <CHOICES>`
- `CHOICES`: _(type: "str")_ Array containing choices.

- ⚠️ Requires: `cut`, `echo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 118. `_yes_no` (private)

Promt user for yes or no

> Synopsis:
> `_yes_no [QUESTION]`
- `QUESTION`: _(type: "str")_ (optional) A string containing the question. _Defaults to "Confirm ?"._

- ⚠️ Requires: `echo`, `grep`

- 🔗 Depends: `src/shell/colors/_echo_success`, `src/shell/colors/_echo_warning`

#### ⌨️ 119. `_get_constants` (private)

List constants from provided shoe script

> Synopsis:
> `_get_constants <SCRIPT_PATH> [GET_PRIVATE]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private constants as well. _Defaults to "false"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 120. `_get_constraint` (private)

Get constaint for given variable from provided shoe script

> Synopsis:
> `_get_constraint <SCRIPT_PATH> <VARIABLE_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `VARIABLE_NAME`: _(type: "str")_ The variable to validate.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 121. `_get_flags` (private)

List flags from provided shoe script

> Synopsis:
> `_get_flags <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 122. `_get_function` (private)

Get function by name

> Synopsis:
> `_get_function <SCRIPT_PATH> <FUNCTION_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 123. `_get_function_parameters` (private)

List options and flags declared in a function shoedoc annotation

> Synopsis:
> `_get_function_parameters <SCRIPT_PATH> <FUNCTION_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to inspect.

- ⚠️ Requires: `awk`, `printf`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/shoedoc/_get_function_shoedoc`

#### ⌨️ 124. `_get_functions_names` (private)

List functions names from provided shoe script

> Synopsis:
> `_get_functions_names <SCRIPT_PATH> [GET_PRIVATE]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private functions as well. _Defaults to "false"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 125. `_get_options` (private)

List options from provided shoe script

> Synopsis:
> `_get_options <SCRIPT_PATH> [GET_PRIVATE_ONLY]`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE_ONLY`: _(type: "bool")_ (optional) If set to "true", retrieves private options only. _Defaults to "false"._

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 126. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script

> Synopsis:
> `_get_padding <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 127. `_get_parameter` (private)

Get value for given parameter from provided ".env" or ".sh" file

> Synopsis:
> `_get_parameter <FILE_PATH> <KEY>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.

- ⚠️ Requires: `realpath`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 128. `_has_parameter` (private)

Tests if parameter exists in provided ".env" or ".sh" file

> Synopsis:
> `_has_parameter <FILE_PATH> <KEY>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.

- ⚠️ Requires: `grep`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 129. `_print_synopsis` (private)

Print function synopsis from shoedoc annotations

> Synopsis:
> `_print_synopsis <FUNCTION_NAME> <ANNOTATIONS> [MARKDOWN_FORMAT]`
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to document.
- `ANNOTATIONS`: _(type: "str")_ The shoedoc annotation block, classic @-tags.
- `MARKDOWN_FORMAT`: _(type: "bool")_ (optional) If set to "true", returns result as markdown. _Defaults to "false"._

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 130. `_set_parameter` (private)

Set value for given parameter into provided file ".env" or ".sh" file

> Synopsis:
> `_set_parameter <FILE_PATH> <KEY> <VALUE>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.
- `VALUE`: _(type: "str")_ The value to be set to provided file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/colors/_echo_warning`, `src/shell/compatibility/_sed_i`, `src/shell/reflexion/_get_parameter`, `src/shell/reflexion/_has_parameter`

#### ⌨️ 131. `_get_function_shoedoc` (private)

Get function shedoc annotation by name

> Synopsis:
> `_get_function_shoedoc <SCRIPT_PATH> <FUNCTION_NAME>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 132. `_get_script_shoedoc` (private)

Get top-level shoedoc annotation of the provided shoe script file

> Synopsis:
> `_get_script_shoedoc <SCRIPT_PATH>`
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 133. `_get_shoedoc` (private)

Get shoedoc annotation

> Synopsis:
> `_get_shoedoc <TEXT>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 134. `_get_shoedoc_description` (private)

Get shoedoc description

> Synopsis:
> `_get_shoedoc_description <TEXT>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 135. `_get_shoedoc_tag` (private)

Return given tag values from shoedoc annotation

> Synopsis:
> `_get_shoedoc_tag <TEXT> <TAG_NAME>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.
- `TAG_NAME`: _(type: "str")_ The name of tag to return.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 136. `_get_shoedoc_title` (private)

Get shoedoc title

> Synopsis:
> `_get_shoedoc_title <TEXT>`
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 137. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"

> Synopsis:
> `_collapse_blank_lines <FILE_PATH>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`

#### ⌨️ 138. `_dedupe_lines` (private)

Remove every line in target file that contains substrings from source file

> Synopsis:
> `_dedupe_lines <SOURCE_PATH> <TARGET_PATH>`
- `SOURCE_PATH`: _(type: "file")_ The path to the file containing the substrings to remove.
- `TARGET_PATH`: _(type: "file")_ The path to the target file to deduplicate.

- ⚠️ Requires: `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`

#### ⌨️ 139. `_generate_key` (private)

Generate random 32 bit string

> Synopsis:
> `_generate_key`

- ⚠️ Requires: `openssl`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 140. `_trim` (private)

Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string

> Synopsis:
> `_trim <STRING>`
- `STRING`: _(type: "str")_ The string to trim.

- ⚠️ Requires: `printf`, `sed`, `tr`

#### ⌨️ 141. `_composer_install` (private)

Install project dependencies with composer

> Synopsis:
> `_composer_install`

- ⚠️ Requires: `composer`, `install`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`, `src/shell/system/_pwd`

#### ⌨️ 142. `_composer_update` (private)

Update project dependencies with composer

> Synopsis:
> `_composer_update`

- ⚠️ Requires: `composer`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 143. `_console` (private)

Get correct Symfony console binary path

> Synopsis:
> `_console`

- ⚠️ Requires: `basename`, `echo`, `symfony`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 144. `_db_create` (private)

Create Symfony database with Doctrine

> Synopsis:
> `_db_create [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_console`

#### ⌨️ 145. `_db_drop` (private)

Drop database with Doctrine

> Synopsis:
> `_db_drop [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_console`

#### ⌨️ 146. `_db_query` (private)

Executes arbitrary SQL directly from the command line

> Synopsis:
> `_db_query [SQL]`
- `SQL`: _(type: "str")_ (optional) SQL query. _Constraint: `/.+/`._

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_console`

#### ⌨️ 147. `_db_schema` (private)

Create schema with Doctrine

> Synopsis:
> `_db_schema [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_console`

#### ⌨️ 148. `_phpunit` (private)

Get correct PHPUnit binary path

> Synopsis:
> `_phpunit`

- ⚠️ Requires: `basename`, `echo`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 149. `_sf_cache` (private)

Clear Symfony cache

> Synopsis:
> `_sf_cache [ENV]`
- `ENV`: _(type: "str")_ (optional) Environment. _Constraint: `/^(dev|prod|test)$/`._

- ⚠️ Requires: `clear`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_console`

#### ⌨️ 150. `_sf_lint` (private)

Run linter (sniff)

> Synopsis:
> `_sf_lint`

- ⚠️ Requires: `composer`, `find`, `php`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/symfony/_console`, `src/shell/system/_check_installed`

#### ⌨️ 151. `_sf_security` (private)

Check security issues in project dependencies (symfony-cli)

> Synopsis:
> `_sf_security`

- ⚠️ Requires: `composer`, `symfony`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/system/_is_installed`

#### ⌨️ 152. `_sf_serve` (private)

Run a local web server with Symfony CLI

> Synopsis:
> `_sf_serve`

- ⚠️ Requires: `symfony`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 153. `_sf_test` (private)

Run test with PHPUnit

> Synopsis:
> `_sf_test [FILE_PATH]`
- `FILE_PATH`: _(type: "file")_ (optional) The path to the input file.

- ⚠️ Requires: `php`, `realpath`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/symfony/_phpunit`

#### ⌨️ 154. `_check_installed` (private)

Print error message if provided command is missing

> Synopsis:
> `_check_installed <COMMAND>`
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_get_package_name`, `src/shell/system/_is_installed`

#### ⌨️ 155. `_get_package_name` (private)

Find package name for given command

> Synopsis:
> `_get_package_name <COMMAND>`
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `echo`, `snap`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 156. `_is_checksum_valid` (private)

Validate a file checksum

> Synopsis:
> `_is_checksum_valid <FILE_PATH> <SHA256SUM>`
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `SHA256SUM`: _(type: "str")_ A string containing file checksum.

- ⚠️ Requires: `awk`, `grep`, `realpath`, `set`, `sha256sum`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/system/_check_installed`

#### ⌨️ 157. `_is_installed` (private)

Check provided command is installed

> Synopsis:
> `_is_installed <COMMAND>`
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `dpkg`, `grep`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 158. `_is_root` (private)

Check current user is root

> Synopsis:
> `_is_root`

- ⚠️ Requires: `awk`, `id`

#### ⌨️ 159. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally

> Synopsis:
> `_pwd`

- ⚠️ Requires: `dirname`, `pwd`, `realpath`

#### ⌨️ 160. `_remove` (private)

Remove given package from system

> Synopsis:
> `_remove <PACKAGE> [PACKAGE_MANAGER]`
- `PACKAGE`: _(type: "str")_ The command/package to remove.
- `PACKAGE_MANAGER`: _(type: "str")_ (optional) The package manager required to remove the package with. _Defaults to "apt"._

- ⚠️ Requires: `apt`, `apt-get`, `snap`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_package_manager`, `src/shell/system/_get_package_name`, `src/shell/system/_is_installed`

#### ⌨️ 161. `_require` (private)

Install required package globally

> Synopsis:
> `_require <PACKAGE> [PACKAGE_MANAGER]`
- `PACKAGE`: _(type: "str")_ The command/package to remove.
- `PACKAGE_MANAGER`: _(type: "str")_ (optional) The package manager required to remove the package with. _Defaults to "apt"._

- ⚠️ Requires: `apt`, `apt-get`, `install`, `snap`, `sudo`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_package_manager`, `src/shell/system/_get_package_name`, `src/shell/system/_is_installed`

#### ⌨️ 162. `_spin` (private)

Animate a spinner in the terminal for a given amout of time

> Synopsis:
> `_spin [DURATION]`
- `DURATION`: _(type: "int")_ (optional) Animation duration in miliseconds. _Defaults to "0"._

- ⚠️ Requires: `awk`, `printf`, `sleep`

#### ⌨️ 163. `_user_exists` (private)

Check provided user exists

> Synopsis:
> `_user_exists <USERNAME>`
- `USERNAME`: _(type: "str")_ The username to check.

- ⚠️ Requires: `id`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 164. `_is_valid` (private)

Checks if variable is valid given regex constraint

> Synopsis:
> `_is_valid <VALUE> <PATTERN>`
- `VALUE`: _(type: "str")_ The string to be compared to regex pattern.
- `PATTERN`: _(type: "str")_ The regex parttern to apply.

- ⚠️ Requires: `grep`, `printf`, `sed`

- 🔗 Depends: `src/shell/colors/_echo_error`

#### ⌨️ 165. `_validate` (private)

Find constraints and validates a variable

> Synopsis:
> `_validate <VARIABLE> [CONSTRAINT]`
- `VARIABLE`: _(type: "str")_ The variable to validate in the followling format : variable_name=value.
- `CONSTRAINT`: _(type: "str")_ (optional) Optional constraint, read from the script when omitted.

- ⚠️ Requires: `cut`, `printf`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/reflexion/_get_constraint`, `src/shell/validation/_is_valid`

#### ⌨️ 166. `_kernel` (private)

Shoe Kernel

> Synopsis:
> `_kernel`

- ⚠️ Requires: `awk`, `false`, `grep`, `printf`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/help/_help`, `src/shell/hooks/_after`, `src/shell/hooks/_before`, `src/shell/hooks/_default`, `src/shell/reflexion/_get_flags`, `src/shell/reflexion/_get_functions_names`, `src/shell/reflexion/_get_options`, `src/shell/validation/_validate`
