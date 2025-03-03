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

#### 1. `hello`

Greets a specified recipient a given number of times (the recipient's name is provided with the "--who" option)


#### 2. `flag_test`

Prints flag status


#### 3. `_private` (private)

Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.


### ⚡ Self Install

#### 1. `self_install`

Install script and enable completion

```json
{
  "namespace": "install",
  "depends": [
    "_install"
  ],
  "assumes": [
    "ALIAS",
    "global"
  ]
}
```


#### 2. `self_uninstall`

Uninstall script from system

```json
{
  "namespace": "install",
  "depends": [
    "_uninstall"
  ],
  "assumes": [
    "ALIAS"
  ]
}
```


#### 3. `self_update`

Update script from @update

```json
{
  "namespace": "install",
  "depends": [
    "_get_annotation_tags",
    "_get_script_shoedoc",
    "_update"
  ],
  "assumes": [
    "ALIAS",
    "global"
  ]
}
```


### ⚡ Documentation

#### 1. `generate_doc`

Generate Markdown documentation for current shoe script

```json
{
  "namespace": "documentation",
  "depends": [
    "_generate_doc"
  ]
}
```


### ⚡ Make

#### 1. `generate_makefile`

Generate Makefile for current shoe script

```json
{
  "namespace": "make",
  "depends": [
    "_generate_makefile"
  ]
}
```


### ⚡ Help

#### 1. `help`

Print this help

```json
{
  "namespace": "help",
  "depends": [
    "_help"
  ]
}
```


### ⚡ Hooks

#### 1. `_default` (private)

Place here commands you need executed by default (optional)

```json
{
  "namespace": "hooks"
}
```


#### 2. `_before` (private)

Place here commands you need executed first every time (optional)

```json
{
  "namespace": "hooks"
}
```


#### 3. `_after` (private)

Place here commands you need executed last every time (optional)

```json
{
  "namespace": "hooks"
}
```


### ⚡ Android

#### 1. `_adb_connect` (private)

Connect to device with adb via wifi (not recommended when flashing images)

```json
{
  "namespace": "android",
  "requires": [
    "adb"
  ],
  "depends": [
    "_check_installed",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "IP",
      "type": "str",
      "description": "Device IP address.",
      "nullable": false,
      "constraint": "/^([0-9]{1,3}\\.){3}[0-9]{1,3}$/"
    },
    {
      "position": 2,
      "name": "PORT",
      "type": "int",
      "default": 5555,
      "description": "Destination port.",
      "constraint": "/^[0-9]{1,5}$/"
    }
  ]
}
```

> Synopsis: _adb_connect &lt;IP&gt; [PORT]<br>
>   IP:   Device IP address.<br>
>   PORT: (optional) Destination port. (default=5555)<br>

#### 2. `_adb_sideload` (private)

Sideload given full OTA package to connected device

```json
{
  "namespace": "android",
  "requires": [
    "adb"
  ],
  "depends": [
    "_check_installed",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _adb_sideload &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 3. `_adb_start_server` (private)

Start local adb server

```json
{
  "namespace": "android",
  "requires": [
    "adb"
  ],
  "depends": [
    "_check_installed",
    "echo_info"
  ]
}
```

> Synopsis: _adb_start_server<br>

#### 4. `_fastboot_lock` (private)

Lock bootloader and flashing

```json
{
  "namespace": "android",
  "requires": [
    "fastboot"
  ],
  "depends": [
    "_is_device_connected_with_fastboot",
    "echo_danger",
    "echo_info"
  ]
}
```

> Synopsis: _fastboot_lock<br>

#### 5. `_fastboot_unlock` (private)

Unlock bootloader and flashing

```json
{
  "namespace": "android",
  "requires": [
    "fastboot"
  ],
  "depends": [
    "_is_device_connected_with_fastboot",
    "echo_danger",
    "echo_info"
  ]
}
```

> Synopsis: _fastboot_unlock<br>

#### 6. `_fastboot_wipe` (private)

Wipe userdata on connected device

```json
{
  "namespace": "android",
  "requires": [
    "fastboot"
  ],
  "depends": [
    "_is_device_connected_with_fastboot",
    "echo_danger",
    "echo_info"
  ]
}
```

> Synopsis: _fastboot_wipe<br>

#### 7. `_flash_img` (private)

Flash img file to connected device provided partition

```json
{
  "namespace": "android",
  "requires": [
    "fastboot"
  ],
  "depends": [
    "_is_device_connected_with_fastboot",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "PARTITION",
      "type": "str",
      "description": "The name of the target partition.",
      "nullable": false
    },
    {
      "position": 3,
      "name": "FORCE",
      "type": "bool",
      "description": "Force install.",
      "default": false
    }
  ]
}
```

> Synopsis: _flash_img &lt;FILE_PATH&gt; &lt;PARTITION&gt; [FORCE]<br>
>   FILE_PATH: The path to the image file.<br>
>   PARTITION: The name of the target partition.<br>
>   FORCE:     (optional) Force install. Defaults to "false".<br>

#### 8. `_get_apk_label` (private)

Get APK label

```json
{
  "namespace": "android",
  "requires": [
    "aapt"
  ],
  "depends": [
    "_check_installed",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_apk_label &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 9. `_get_apk_package_name` (private)

Get APK package_name

```json
{
  "namespace": "android",
  "requires": [
    "aapt"
  ],
  "depends": [
    "_check_installed",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_apk_package_name &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 10. `_get_apk_path` (private)

Get installed APK path on connected device from package name

```json
{
  "namespace": "android",
  "requires": [
    "adb"
  ],
  "depends": [
    "_is_device_connected_with_adb",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "PACKAGE_NAME",
      "type": "str",
      "description": "The apk package name. eg: \"org.fdroid.fdroid\"",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_apk_path &lt;PACKAGE_NAME&gt;<br>
>   PACKAGE_NAME: The apk package name. eg: "org.fdroid.fdroid"<br>

#### 11. `_get_apk_version` (private)

Get APK version

```json
{
  "namespace": "android",
  "requires": [
    "aapt"
  ],
  "depends": [
    "_check_installed",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_apk_version &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 12. `_install_apk` (private)

Install APK on connected device

```json
{
  "namespace": "android",
  "requires": [
    "adb"
  ],
  "depends": [
    "_is_device_connected_with_adb",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "FORCE",
      "type": "bool",
      "description": "Force install.",
      "default": false
    }
  ]
}
```

> Synopsis: _install_apk &lt;FILE_PATH&gt; [FORCE]<br>
>   FILE_PATH: The path to the input file.<br>
>   FORCE:     (optional) Force install. Defaults to "false".<br>

#### 13. `_is_apk_installed` (private)

Check if package is installed on connected device

```json
{
  "namespace": "android",
  "requires": [
    "adb"
  ],
  "depends": [
    "_is_device_connected_with_adb",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "PACKAGE_NAME",
      "type": "str",
      "description": "The apk package name. eg: \"org.fdroid.fdroid\"",
      "nullable": false
    }
  ]
}
```

> Synopsis: _is_apk_installed &lt;PACKAGE_NAME&gt;<br>
>   PACKAGE_NAME: The apk package name. eg: "org.fdroid.fdroid"<br>

#### 14. `_is_device_connected_with_adb` (private)

Check device is connected with adb

```json
{
  "namespace": "android",
  "requires": [
    "adb"
  ],
  "depends": [
    "_check_installed"
  ]
}
```

> Synopsis: _is_device_connected_with_adb<br>

#### 15. `_is_device_connected_with_fastboot` (private)

Check device is connected with fastboot

```json
{
  "namespace": "android",
  "requires": [
    "fastboot"
  ],
  "depends": [
    "_check_installed"
  ]
}
```

> Synopsis: _is_device_connected_with_fastboot<br>

#### 16. `_list_installed_apks` (private)

List installed packages on connected device

```json
{
  "namespace": "android",
  "requires": [
    "adb"
  ],
  "depends": [
    "_is_device_connected_with_adb",
    "echo_danger"
  ]
}
```

> Synopsis: _list_installed_apks<br>

#### 17. `_pull_apk` (private)

Copy APK from connected device to local folder

```json
{
  "namespace": "android",
  "requires": [
    "adb"
  ],
  "depends": [
    "_is_device_connected_with_adb",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "PACKAGE_NAME",
      "type": "str",
      "description": "The apk package name. eg: \"org.fdroid.fdroid\"",
      "nullable": false
    },
    {
      "position": 2,
      "name": "DESTINATION",
      "type": "folder",
      "description": "The path to the destination folder.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _pull_apk &lt;PACKAGE_NAME&gt; &lt;DESTINATION&gt;<br>
>   PACKAGE_NAME: The apk package name. eg: "org.fdroid.fdroid"<br>
>   DESTINATION:  The path to the destination folder.<br>

#### 18. `_reboot_bootloader` (private)

Reboot connected device to bootloader

```json
{
  "namespace": "android",
  "requires": [
    "adb",
    "fastboot"
  ],
  "depends": [
    "_is_device_connected_with_adb",
    "_is_device_connected_with_fastboot",
    "echo_danger",
    "echo_info"
  ]
}
```

> Synopsis: _reboot_bootloader<br>

#### 19. `_reboot_recovery` (private)

Reboot connected device to recovery

```json
{
  "namespace": "android",
  "requires": [
    "adb",
    "fastboot"
  ],
  "depends": [
    "_is_device_connected_with_adb",
    "_is_device_connected_with_fastboot",
    "echo_danger",
    "echo_info"
  ]
}
```

> Synopsis: _reboot_recovery<br>

#### 20. `_reboot_system` (private)

Reboot connected device to system

```json
{
  "namespace": "android",
  "requires": [
    "adb",
    "fastboot"
  ],
  "depends": [
    "_is_device_connected_with_adb",
    "_is_device_connected_with_fastboot",
    "echo_danger",
    "echo_info"
  ]
}
```

> Synopsis: _reboot_system<br>

#### 21. `_reboot_with_img` (private)

Boot connected device with given image temporarily

```json
{
  "namespace": "android",
  "requires": [
    "fastboot"
  ],
  "depends": [
    "_is_device_connected_with_fastboot",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _reboot_with_img &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 22. `_remove_apk` (private)

Remove APK from connected device

```json
{
  "namespace": "android",
  "requires": [
    "adb"
  ],
  "depends": [
    "_is_device_connected_with_adb",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "PACKAGE_NAME",
      "type": "str",
      "description": "The apk package name. eg: \"org.fdroid.fdroid\"",
      "nullable": false
    },
    {
      "position": 2,
      "name": "FORCE",
      "type": "bool",
      "description": "Force install.",
      "default": false
    }
  ]
}
```

> Synopsis: _remove_apk &lt;PACKAGE_NAME&gt; [FORCE]<br>
>   PACKAGE_NAME: The apk package name. eg: "org.fdroid.fdroid"<br>
>   FORCE:        (optional) Force install. Defaults to "false".<br>

#### 23. `_toggle_active_slot` (private)

Toggle connected device active slot

```json
{
  "namespace": "android",
  "requires": [
    "fastboot"
  ],
  "depends": [
    "_is_device_connected_with_fastboot",
    "echo_danger",
    "echo_info"
  ]
}
```

> Synopsis: _toggle_active_slot<br>

### ⚡ Bashdoc

#### 1. `_get_shoedoc_description` (private)

Get shoedoc description

```json
{
  "namespace": "shoedoc",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "TEXT",
      "type": "str",
      "description": "The input shoedoc annotation bloc.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_shoedoc_description &lt;TEXT&gt;<br>
>   TEXT: The input shoedoc annotation bloc.<br>

#### 2. `_get_shoedoc` (private)

Get shoedoc

```json
{
  "namespace": "shoedoc",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "TEXT",
      "type": "str",
      "description": "The input shoedoc annotation bloc.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_shoedoc &lt;TEXT&gt;<br>
>   TEXT: The input shoedoc annotation bloc.<br>
>   note: Remove every line that does not start with a pound character or contains a tag<br>
>         Returns string without leading pound characters<br>

#### 3. `_get_shoedoc_tag` (private)

Return given tag values from shoedoc bloc

```json
{
  "namespace": "shoedoc",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "TEXT",
      "type": "str",
      "description": "The input shoedoc annotation bloc.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "TAG_NAME",
      "type": "str",
      "description": "The name of tag to return.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_shoedoc_tag &lt;TEXT&gt; &lt;TAG_NAME&gt;<br>
>   TEXT:     The input shoedoc annotation bloc.<br>
>   TAG_NAME: The name of tag to return.<br>

#### 4. `_get_shoedoc_title` (private)

Get shoedoc title

```json
{
  "namespace": "shoedoc",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "TEXT",
      "type": "str",
      "description": "The input shoedoc annotation bloc.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_shoedoc_title &lt;TEXT&gt;<br>
>   TEXT: The input shoedoc annotation bloc.<br>
>   note: Returns the first line that does not contain a tag<br>

#### 5. `_get_script_shoedoc` (private)

Get shoedoc bloc at the top the provided shoe script file

```json
{
  "namespace": "shoedoc",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_script_shoedoc &lt;SCRIPT_PATH&gt;<br>
>   SCRIPT_PATH: The path to the input script.<br>
>   note:        Each shoedoc should strictly start with two pound signs (##)<br>
>                Returns the first valid docbloc found in the provided file<br>

### ⚡ Colors

#### 1. `echo_primary` (private)

Print primary text with optional indentation and padding

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "INDENTATION",
      "type": "int",
      "description": "Indentation level.",
      "default": 0
    },
    {
      "position": 3,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 0
    }
  ]
}
```

> Synopsis: echo_primary &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:      Text to display.<br>
>  INDENTATION: Indentation level (default: 0).<br>
>  PADDING:     Padding length (default: 0).<br>
>  note:        Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>               this is why we're calculating the PADDING length on each execution.<br>

#### 2. `echo_secondary` (private)

Print secondary text with optional indentation and padding

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "INDENTATION",
      "type": "int",
      "description": "Indentation level.",
      "default": 0
    },
    {
      "position": 3,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 0
    }
  ]
}
```

> Synopsis: echo_secondary &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 3. `echo_success` (private)

Print success text with optional indentation and padding

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "INDENTATION",
      "type": "int",
      "description": "Indentation level.",
      "default": 0
    },
    {
      "position": 3,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 0
    }
  ]
}
```

> Synopsis: echo_success &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 4. `echo_danger` (private)

Print danger text with optional indentation and padding

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "INDENTATION",
      "type": "int",
      "description": "Indentation level.",
      "default": 0
    },
    {
      "position": 3,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 0
    }
  ]
}
```

> Synopsis: echo_danger &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 5. `echo_warning` (private)

Print warning text with optional indentation and padding

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "INDENTATION",
      "type": "int",
      "description": "Indentation level.",
      "default": 0
    },
    {
      "position": 3,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 0
    }
  ]
}
```

> Synopsis: echo_warning &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 6. `echo_info` (private)

Print info text with optional indentation and padding

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "INDENTATION",
      "type": "int",
      "description": "Indentation level.",
      "default": 0
    },
    {
      "position": 3,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 0
    }
  ]
}
```

> Synopsis: echo_info &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 7. `echo_light` (private)

Print light text with optional indentation and padding

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "INDENTATION",
      "type": "int",
      "description": "Indentation level.",
      "default": 0
    },
    {
      "position": 3,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 0
    }
  ]
}
```

> Synopsis: echo_light &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 8. `echo_dark` (private)

Print dark text with optional indentation and padding

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "INDENTATION",
      "type": "int",
      "description": "Indentation level.",
      "default": 0
    },
    {
      "position": 3,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 0
    }
  ]
}
```

> Synopsis: echo_dark &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 9. `alert_primary` (private)

Print primary alert

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    }
  ]
}
```

> Synopsis: alert_primary &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 10. `alert_secondary` (private)

Print secondary alert

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    }
  ]
}
```

> Synopsis: alert_secondary &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 11. `alert_success` (private)

Print success alert

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    }
  ]
}
```

> Synopsis: alert_success &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 12. `alert_danger` (private)

Print danger alert

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    }
  ]
}
```

> Synopsis: alert_danger &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 13. `alert_warning` (private)

Print warning alert

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    }
  ]
}
```

> Synopsis: alert_warning &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 14. `alert_info` (private)

Print info alert

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    }
  ]
}
```

> Synopsis: alert_info &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 15. `alert_light` (private)

Print light alert

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    }
  ]
}
```

> Synopsis: alert_light &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 16. `alert_dark` (private)

Print dark alert

```json
{
  "namespace": "colors",
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "Text to display.",
      "nullable": false
    }
  ]
}
```

> Synopsis: alert_dark &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

### ⚡ Compatibility

#### 1. `_open` (private)

Open with default system handler

```json
{
  "namespace": "compatibility",
  "requires": [
    "uname"
  ]
}
```

> Synopsis: _open<br>

#### 2. `_sed_i` (private)

Return sed -i system flavour

```json
{
  "namespace": "compatibility",
  "requires": [
    "command",
    "sed",
    "uname"
  ]
}
```

> Synopsis: _sed_i<br>

### ⚡ Docker

#### 1. `_docker_compose_build` (private)

Build container stack with docker compose

```json
{
  "namespace": "docker",
  "depends": [
    "_get_docker_compose",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the compose.yaml file.","
      "nullable": false
    }
  ]
}
```

> Synopsis: _docker_compose_build &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the compose.yaml file.<br>

#### 2. `_docker_compose_start` (private)

Build and start container stack with docker compose

```json
{
  "namespace": "docker",
  "depends": [
    "_get_docker_compose",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the compose.yaml file.","
      "nullable": false
    }
  ]
}
```

> Synopsis: _docker_compose_start &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the compose.yaml file.<br>

#### 3. `_docker_compose_stop` (private)

Stop container stack with docker compose

```json
{
  "namespace": "docker",
  "depends": [
    "_get_docker_compose",
    "echo_info"
  ]
}
```

> Synopsis: _docker_compose_stop<br>

#### 4. `_docker_exec` (private)

Execute command in the given docker container

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "CONTAINER_NAME",
      "type": "str",
      "description": "The name of the container to run.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "COMMAND",
      "type": "str",
      "description": "The command to execute.",
      "nullable": false
    },
    {
      "position": 3,
      "name": "USER",
      "type": "str",
      "description": "The user name."
    }
  ]
}
```

> Synopsis: _docker_exec &lt;CONTAINER_NAME&gt; &lt;COMMAND&gt; [USER]<br>
>   CONTAINER_NAME: The name of the container to run.<br>
>   COMMAND:        The command to execute.<br>
>   USER:           (optional) The user name.<br>

#### 5. `_docker_kill_all` (private)

Kill all running containers with docker

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_info"
  ]
}
```

> Synopsis: _docker_kill_all<br>

#### 6. `_docker_rm` (private)

Remove given docker container

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "CONTAINER_NAME",
      "type": "str",
      "description": "The name of the container to run.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _docker_rm &lt;CONTAINER_NAME&gt;<br>
>   CONTAINER_NAME: The name of the container to remove.<br>

#### 7. `_docker_run_atmoz_sftp` (private)

Run local atmoz_sftp server

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "USERNAME",
      "type": "str",
      "description": "The name of the container to run.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "PASSWORD",
      "type": "str",
      "description": "The password for the sftp server access.",
      "nullable": false
    },
    {
      "position": 3,
      "name": "NETWORK_MODE",
      "type": "str",
      "description": "The user name.",
      "constraint": "/^(bridge|host)$/"
    },
    {
      "position": 4,
      "name": "FOLDER_PATH",
      "type": "folder",
      "description": "The path to the volume folder."
    }
  ]
}
```

> Synopsis: _docker_run_atmoz_sftp &lt;USERNAME&gt; &lt;PASSWORD&gt; [NETWORK_MODE] [FOLDER_PATH]<br>
>   USERNAME:     The username for the sftp server access.<br>
>   PASSWORD:     The password for the sftp server access.<br>
>   NETWORK_MODE: (optional) Set network mode (bridge|host). Defaults to "bridge".<br>
>   FOLDER_PATH:  (optional) The path to the volume folder.<br>
>   note:         atmoz_sftp documentation: https://github.com/atmoz/sftp<br>

#### 8. `_docker_run` (private)

Spawn a new container with given image, name, command and volume

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "IMAGE",
      "type": "str",
      "description": "The name of the container image to run.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "NAME",
      "type": "str",
      "description": "Assign a name to the container.",
      "nullable": false
    },
    {
      "position": 3,
      "name": "COMMAND",
      "type": "str",
      "description": "The command to run inside provided container.",
      "nullable": false
    },
    {
      "position": 4,
      "name": "FOLDER_PATH",
      "type": "folder",
      "description": "The path to the volume folder."
    }
  ]
}
```

> Synopsis: _docker_run &lt;IMAGE&gt; &lt;NAME&gt; &lt;COMMAND&gt; [FOLDER_PATH]<br>
>   IMAGE:       The name of the container image to run.<br>
>   NAME:        Assign a name to the container.<br>
>   COMMAND:     The command to run inside provided container.<br>
>   FOLDER_PATH: (optional) The path to the volume folder.<br>

#### 9. `_docker_run_whoami` (private)

Run local whoami server

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_info"
  ]
}
```

> Synopsis: _docker_run_whoami<br>
>   note: traefik_whoami documentation: https://github.com/traefik/whoami<br>

#### 10. `_docker_status` (private)

Print docker status

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_info"
  ]
}
```

> Synopsis: _docker_status<br>

#### 11. `_find_container_name` (private)

Find container name from string

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "STRING",
      "type": "str",
      "description": "The string to find among running containers.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _find_container_name &lt;STRING&gt;<br>
>   STRING: The string to find among running containers.<br>

#### 12. `_get_container_id` (private)

Get container id from name

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "CONTAINER_NAME",
      "type": "str",
      "description": "The name of the container to run.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "TRUNCATE",
      "type": "bool",
      "description": "Truncate id to 12 characters long.",
      "default": true
    }
  ]
}
```

> Synopsis: _get_container_id &lt;CONTAINER_NAME&gt; [TRUNCATE]<br>
>   CONTAINER_NAME: The container name.<br>
>   TRUNCATE:       Truncate id to 12 characters long. Defaults to "true".<br>

#### 13. `_get_container_ip` (private)

Get running container ip

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "CONTAINER_NAME|CONTAINER_ID",
      "type": "str",
      "description": "The name or the id of the docker container.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_container_ip &lt;CONTAINER_NAME|CONTAINER_ID&gt;<br>
>   CONTAINER_NAME: The name of the docker container.<br>
>   CONTAINER_ID:   The id of the docker container.<br>

#### 14. `_get_container_name` (private)

Get container name from id

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "CONTAINER_ID",
      "type": "str",
      "description": "The container id.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_container_name &lt;CONTAINER_ID&gt;<br>
>   CONTAINER_ID: The container id.<br>

#### 15. `_get_docker_compose` (private)

Return docker compose command

```json
{
  "namespace": "docker",
  "requires": [
    "command",
    "docker"
  ],
  "depends": [
    "echo_danger"
  ]
}
```

> Synopsis: _get_docker_compose<br>

#### 16. `_is_container_running` (private)

Checks if given container is running

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "CONTAINER_NAME|CONTAINER_ID",
      "type": "str",
      "description": "The name or the id of the docker container.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _is_container_running &lt;CONTAINER_NAME|CONTAINER_ID&gt;<br>
>   CONTAINER_NAME: The name of the docker container.<br>
>   CONTAINER_ID:   The id of the docker container.<br>

#### 17. `_wait_for_postgres` (private)

Wait for postgresql container to start with docker

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "_spin",
    "echo_danger",
    "echo_success",
    "echo_warning"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "CONTAINER_NAME",
      "type": "str",
      "description": "The name of the docker container.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "USERNAME",
      "type": "str",
      "description": "The psql username.",
      "default": ""
    }
  ]
}
```

> Synopsis: _wait_for_postgres &lt;CONTAINER_NAME&gt; [USERNAME]<br>
>   CONTAINER_NAME: The name of the postgresql docker container.<br>
>   USERNAME:       (optional) The psql username. Defaults to "".<br>

#### 18. `_wait_for_rabbit` (private)

Wait for rabbitmq container to start with docker

```json
{
  "namespace": "docker",
  "requires": [
    "docker"
  ],
  "depends": [
    "_check_installed",
    "_spin",
    "echo_danger",
    "echo_success",
    "echo_warning"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "CONTAINER_NAME",
      "type": "str",
      "description": "The name of the docker container.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _wait_for_rabbit &lt;CONTAINER_NAME&gt;<br>
>   CONTAINER_NAME: The name of the rabbitmq docker container.<br>

### ⚡ Documentation

#### 1. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script

```json
{
  "namespace": "documentation",
  "requires": [
    "awk"
  ],
  "depends": [
    "_get_script_shoedoc",
    "_get_shoedoc_description",
    "_get_shoedoc_tag",
    "_get_shoedoc_title",
    "alert_primary",
    "echo_danger",
    "echo_success"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "DESTINATION",
      "type": "folder",
      "description": "The path to the destination folder. Defaults to file parent."
    },
    {
      "position": 3,
      "name": "OUTPUT_FILE_NAME",
      "type": "str",
      "description": "The name for the documentation file. Defaults to \"<BASENAME>.md\"."
    },
    {
      "position": 4,
      "name": "GET_PRIVATE",
      "type": "bool",
      "description": "If set to \"true\", documents private constants, options, flags, and commands as well.",
      "default": false
    }
  ]
}
```

> Synopsis: _generate_doc &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]<br>
>   SCRIPT_PATH:      The path to the input file.<br>
>   DESTINATION:      (optional) The path to the destination folder. Defaults to file parent.<br>
>   OUTPUT_FILE_NAME: (optional) The name for the documentation file. Defaults to "&lt;BASENAME&gt;.md".<br>
>   GET_PRIVATE:      (Optional) If set to 'true', documents private constants, options, flags, and commands as well. Defaults to "false".<br>

### ⚡ Files

#### 1. `_get_file_extension` (private)

Get file extension

```json
{
  "namespace": "files",
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_file_extension &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 2. `_move` (private)

Move file to destination folder (creates folder when missing)

```json
{
  "namespace": "files",
  "depends": [
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 1,
      "name": "DESTINATION_FOLDER",
      "type": "folder",
      "description": "The path to the destination folder.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _move &lt;FILE_PATH&gt; &lt;DESTINATION_FOLDER&gt;<br>
>   FILE_PATH:          The path to the input file.<br>
>   DESTINATION_FOLDER: The path to the destination folder.<br>

### ⚡ Git

#### 1. `_git_hooks` (private)

Update .git/hooks folder

```json
{
  "namespace": "git",
  "requires": [
    "git"
  ],
  "depends": [
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SOURCE",
      "type": "folder",
      "description": "The source directory.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _git_hooks &lt;SOURCE&gt;<br>
>   SOURCE: The source directory.<br>

#### 2. `_initialise_submodules` (private)

Initialise git submodules

```json
{
  "namespace": "git",
  "requires": [
    "git"
  ],
  "depends": [
    "echo_danger",
    "echo_info"
  ]
}
```

> Synopsis: _initialise_submodules<br>

### ⚡ Help

#### 1. `_help` (private)

Print help for provider shoe script

```json
{
  "namespace": "help",
  "depends": [
    "_get_constants",
    "_get_flags",
    "_get_options",
    "_get_padding",
    "_get_script_shoedoc",
    "_get_shoedoc_description",
    "_get_shoedoc_title",
    "_print_commands",
    "_print_constants",
    "_print_description",
    "_print_flags",
    "_print_infos",
    "_print_options",
    "_print_usage",
    "alert_primary",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _help &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 2. `_print_commands` (private)

List commands of the provided shoe script (used by "help" command)

```json
{
  "namespace": "help",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger",
    "echo_warning"
  ],
  "assumes": [
    "PRIMARY",
    "SUCCESS",
    "WARNING"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 12
    }
  ]
}
```

> Synopsis: _print_commands &lt;FILE_PATH&gt; [PADDING]<br>
>   FILE_PATH: The path to the input file.<br>
>   PADDING:   (optional) Padding length (default: 12)<br>
>   note:      "awk: %*x formats are not supported"<br>

#### 3. `_print_constants` (private)

List constants of the provided shoe script (used by "help" command)

```json
{
  "namespace": "help",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger",
    "echo_warning"
  ],
  "assumes": [
    "EOL",
    "INFO",
    "PRIMARY",
    "SUCCESS",
    "WARNING"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 12
    }
  ]
}
```

> Synopsis: _print_constants &lt;FILE_PATH&gt; [PADDING]<br>
>   FILE_PATH: The path to the input file.<br>
>   PADDING:   (optional) Padding length (default: 12)<br>
>   note:      "awk: %*x formats are not supported"<br>

#### 4. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)

```json
{
  "namespace": "help",
  "depends": [
    "echo_primary",
    "echo_warning"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "DESCRIPTION",
      "type": "str",
      "description": "A string containing script description.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _print_description &lt;DESCRIPTION&gt;<br>
>   DESCRIPTION: A string containing script description.<br>

#### 5. `_print_flags` (private)

List flags of the provided shoe script (used by "help" command)

```json
{
  "namespace": "help",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger",
    "echo_warning"
  ],
  "assumes": [
    "PRIMARY",
    "SUCCESS"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 12
    }
  ]
}
```

> Synopsis: _print_flags &lt;FILE_PATH&gt; [PADDING]<br>
>   FILE_PATH: The path to the input file.<br>
>   PADDING:   (optional) Padding length (default: 12)<br>
>   note:      "awk: %*x formats are not supported"<br>

#### 6. `_print_infos` (private)

Print infos of the provided shoe script (used by "help" command)

```json
{
  "namespace": "help",
  "depends": [
    "_get_script_shoedoc",
    "_get_shoedoc_tag",
    "echo_danger",
    "echo_primary",
    "echo_success",
    "echo_warning"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _print_infos &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 7. `_print_options` (private)

List options of the provided shoe script (used by "help" command)

```json
{
  "namespace": "help",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger",
    "echo_warning"
  ],
  "assumes": [
    "DEFAULT",
    "EOL",
    "INFO",
    "SUCCESS",
    "WARNING"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "PADDING",
      "type": "int",
      "description": "Padding length.",
      "default": 12
    }
  ]
}
```

> Synopsis: _print_options &lt;FILE_PATH&gt; [PADDING]<br>
>   FILE_PATH: The path to the input file.<br>
>   PADDING:   (optional) Padding length (default: 12)<br>
>   note:      "awk: %*x formats are not supported"<br>

#### 8. `_print_usage` (private)

Print usage of the provided shoe script (used by "help" command)

```json
{
  "namespace": "help",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger",
    "echo_info",
    "echo_success",
    "echo_warning"
  ],
  "assumes": [
    "DEFAULT",
    "INFO",
    "SUCCESS",
    "WARNING"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _print_usage &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

### ⚡ Install

#### 1. `_copy_install` (private)

Install script via copy

```json
{
  "namespace": "install",
  "depends": [
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "ALIAS",
      "type": "str",
      "description": "The alias of the script to install. Defaults to the basename of the provided file."
    }
  ]
}
```

> Synopsis: _copy_install &lt;FILE_PATH&gt; [ALIAS]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided file<br>
>   note:      Creates a symbolic link in the /usr/local/bin/ directory.<br>

#### 2. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file

```json
{
  "namespace": "install",
  "depends": [
    "_get_comspec",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "ALIAS",
      "type": "str",
      "description": "The alias of the script to install. Defaults to the basename of the provided file."
    }
  ]
}
```

> Synopsis: _generate_autocomplete &lt;FILE_PATH&gt; [ALIAS]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file<br>
>   note:      This function creates a completion script named "&lt;ALIAS&gt;-completion.sh" in the same directory as the script itself.<br>
>              Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.<br>
>              Or read the official docmentation for "complete" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins<br>

#### 3. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file

```json
{
  "namespace": "install",
  "depends": [
    "_get_comspec",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "ALIAS",
      "type": "str",
      "description": "The alias of the script to install. Defaults to the basename of the provided file."
    }
  ]
}
```

> Synopsis: _generate_global_autocomplete &lt;FILE_PATH&gt; [ALIAS]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file<br>
>   note:      This function creates a completion script named "&lt;ALIAS&gt;" (where "&lt;ALIAS&gt;" is the basename of the provided file)<br>
>              in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.<br>
>              It uses sudo for file creation in a system directory, requiring root privileges.<br>

#### 4. `_get_comspec` (private)

Generate comspec string for the provided file

```json
{
  "namespace": "install",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_comspec &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 5. `_install` (private)

Install script and enable completion

```json
{
  "namespace": "install",
  "depends": [
    "_copy_install",
    "_generate_autocomplete",
    "_generate_global_autocomplete",
    "_is_installed",
    "_set_completion_autoload",
    "_symlink_install",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "ALIAS",
      "type": "str",
      "description": "The alias of the script to install. Defaults to the basename of the provided file."
    },
    {
      "position": 3,
      "name": "GLOBAL",
      "type": "bool",
      "description": "Install globally.",
      "default": false
    }
  ]
}
```

> Synopsis: _install &lt;FILE_PATH&gt; [ALIAS] [GLOBAL]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided script.<br>
>   GLOBAL:    (optional) Install globally. Defaults to "false".<br>

#### 6. `_remove_completion_autoload` (private)

Remove completion script autoload

```json
{
  "namespace": "install",
  "depends": [
    "_sed_i",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SHELL_CONFIG_FILE",
      "type": "file",
      "description": "The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).",
      "nullable": false
    },
    {
      "position": 2,
      "name": "ALIAS",
      "type": "str",
      "description": "The alias of the script to install. Defaults to the basename of the provided file."
    }
  ]
}
```

> Synopsis: _remove_completion_autoload &lt;SHELL_CONFIG_FILE&gt; [ALIAS]<br>
> Removes an autoload line for a completion script from a shell configuration file.<br>
>   SHELL_CONFIG_FILE: The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).<br>
>   ALIAS:             (optional) The alias of the script to remove. Defaults to the basename of the provided file<br>

#### 7. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file

```json
{
  "namespace": "install",
  "depends": [
    "_collapse_blank_lines",
    "_sed_i",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SHELL_CONFIG_FILE",
      "type": "file",
      "description": "The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).",
      "nullable": false
    },
    {
      "position": 2,
      "name": "SCRIPT_FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 3,
      "name": "ALIAS",
      "type": "str",
      "description": "The alias of the script to install. Defaults to the basename of the provided file."
    }
  ]
}
```

> Synopsis: _set_completion_autoload &lt;SHELL_CONFIG_FILE_PATH&gt; &lt;SCRIPT_FILE_PATH&gt; [ALIAS]<br>
>   SHELL_CONFIG_FILE_PATH: The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).<br>
>   SCRIPT_FILE_PATH:       The path to the input file.<br>
>   ALIAS:                  (optional) The alias of the input script. Defaults to the basename of the provided file<br>

#### 8. `_symlink_install` (private)

Install script via symlink

```json
{
  "namespace": "install",
  "depends": [
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "ALIAS",
      "type": "str",
      "description": "The alias of the script to install. Defaults to the basename of the provided file."
    }
  ]
}
```

> Synopsis: _symlink_install &lt;FILE_PATH&gt; [ALIAS]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided file<br>
>   note:      Creates a symbolic link in the /usr/local/bin/ directory.<br>

#### 9. `_uninstall` (private)

Uninstall script from system

```json
{
  "namespace": "install",
  "depends": [
    "_remove_completion_autoload",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "ALIAS",
      "type": "str",
      "description": "The alias of the script to install. Defaults to the basename of the provided file."
    }
  ]
}
```

> Synopsis: _uninstall &lt;FILE_PATH&gt; [ALIAS]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to uninstall. Defaults to the basename of the provided script.<br>

#### 10. `_update` (private)

Updates given script from the provided URL

```json
{
  "namespace": "install",
  "requires": [
    "curl",
    "wget"
  ],
  "depends": [
    "_copy_install",
    "_generate_autocomplete",
    "_generate_global_autocomplete",
    "_install",
    "_is_installed",
    "_set_completion_autoload",
    "_symlink_install",
    "_uninstall",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "URL",
      "type": "str",
      "description": "The URL of the script to download and install.",
      "nullable": false
    },
    {
      "position": 3,
      "name": "ALIAS",
      "type": "str",
      "description": "The alias of the script to install. Defaults to the basename of the provided file."
    },
    {
      "position": 4,
      "name": "GLOBAL",
      "type": "bool",
      "description": "Install globally.",
      "default": false
    }
  ]
}
```

> Synopsis: _update &lt;FILE_PATH&gt; &lt;URL&gt; [ALIAS] [GLOBAL]<br>
>   FILE_PATH: The path to the input file.<br>
>   URL:       The URL of the script to download and install.<br>
>   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided script.<br>
>   GLOBAL:    (optional) Install globally. Defaults to "false".<br>

### ⚡ Make

#### 1. `_generate_makefile` (private)

Generate Makefile for provided shoe script

```json
{
  "namespace": "make",
  "requires": [
    "awk"
  ],
  "depends": [
    "_get_script_shoedoc",
    "_get_shoedoc_description",
    "_get_shoedoc_tag",
    "_get_shoedoc_title",
    "alert_primary",
    "echo_danger",
    "echo_success"
  ],
  "assumes": [
    "ALERT_DANGER",
    "ALERT_DARK",
    "ALERT_INFO",
    "ALERT_LIGHT",
    "ALERT_PRIMARY",
    "ALERT_SECONDARY",
    "ALERT_SUCCESS",
    "ALERT_WARNING",
    "DANGER",
    "DARK",
    "DEFAULT",
    "EOL",
    "INFO",
    "LIGHT",
    "PRIMARY",
    "SECONDARY",
    "SUCCESS",
    "WARNING"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "DESTINATION",
      "type": "folder",
      "description": "The path to the destination folder. Defaults to file parent."
    },
    {
      "position": 3,
      "name": "OUTPUT_FILE_NAME",
      "type": "str",
      "description": "The name for the generated Makefile. Defaults to \"<BASENAME>.makefile\"."
    }
  ]
}
```

> Synopsis: _generate_makefile &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME]<br>
>   SCRIPT_PATH:      The path to the input script.<br>
>   DESTINATION:      (optional) The path to the destination folder. Defaults to file parent.<br>
>   OUTPUT_FILE_NAME: (optional) The name for the generated Makefile. Defaults to "&lt;BASENAME&gt;.makefile".<br>

### ⚡ Network

#### 1. `_open_in_default_browser` (private)

Open in default browser

```json
{
  "namespace": "network",
  "depends": [
    "_open",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "IP",
      "type": "str",
      "description": "Target IP address or domain.",
      "default": "127.0.0.1"
    },
    {
      "position": 2,
      "name": "PORT",
      "type": "int",
      "description": "Destination port.",
      "default": "8080",
      "constraint": "/^[0-9]{1,5}$/"
    }
  ]
}
```

> Synopsis: _open_in_default_browser [IP] [PORT]<br>
>   IP:   (optional) Target IP address or domain. (default=127.0.0.1)<br>
>   PORT: (optional) Destination port. (default=8080)<br>

#### 2. `_php_serve` (private)

Serve given local directory with PHP

```json
{
  "namespace": "network",
  "requires": [
    "php"
  ],
  "depends": [
    "_check_installed",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "DOCROOT",
      "type": "folder",
      "description": "The path to the root directory.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "IP",
      "type": "str",
      "description": "Target IP address or domain.",
      "default": "127.0.0.1"
    },
    {
      "position": 3,
      "name": "PORT",
      "type": "int",
      "description": "Destination port.",
      "default": "8080",
      "constraint": "/^[0-9]{1,5}$/"
    }
  ]
}
```

> Synopsis: _php_serve &lt;DOCROOT&gt; [IP] [PORT]<br>
>   DOCROOT: The root directory.<br>
>   IP:      (optional) Local IP address. (default=127.0.0.1)<br>
>   PORT:    (optional) Destination port. (default=8080)<br>

#### 3. `_py_serve` (private)

Serve given local directory with Python 3

```json
{
  "namespace": "network",
  "requires": [
    "python3"
  ],
  "depends": [
    "_check_installed",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "DOCROOT",
      "type": "folder",
      "description": "The path to the root directory.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "IP",
      "type": "str",
      "description": "Target IP address or domain.",
      "default": "127.0.0.1"
    },
    {
      "position": 3,
      "name": "PORT",
      "type": "int",
      "description": "Destination port.",
      "default": "8080",
      "constraint": "/^[0-9]{1,5}$/"
    }
  ]
}
```

> Synopsis: _py_serve &lt;DOCROOT&gt; [IP] [PORT]<br>
>   DOCROOT: The root directory.<br>
>   IP:      (optional) Local IP address. (default=127.0.0.1)<br>
>   PORT:    (optional) Destination port. (default=8080)<br>

#### 4. `_remove_host` (private)

Remove hostname from /etc/hosts

```json
{
  "namespace": "network",
  "depends": [
    "_sed_i",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "HOSTNAME",
      "type": "str",
      "description": "The hostame to unset locally.",
      "nullable": false
    }
  ]
}
```

> Synopsis: remove_host &lt;HOSTNAME&gt;<br>
>   HOSTNAME: The hostame to unset locally.<br>

#### 5. `_set_host` (private)

Set new host in /etc/hosts

```json
{
  "namespace": "network",
  "depends": [
    "_remove_host",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "HOSTNAME",
      "type": "str",
      "description": "The hostame to set locally.",
      "nullable": false
    }
  ]
}
```

> Synopsis: set_host &lt;HOSTNAME&gt;<br>
>   HOSTNAME: The hostame to set locally.<br>

### ⚡ Prompts

#### 1. `_select` (private)

Present user with a list of choices and prompt them to select one

```json
{
  "namespace": "prompts",
  "depends": [
    "echo_danger",
    "echo_success",
    "echo_warning"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "CHOICES",
      "type": "str",
      "description": "Array containing choices.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _select &lt;CHOICES&gt;<br>
>   CHOICES: Array containing choices<br>

#### 2. `_yes_no` (private)

Promt user for yes or no

```json
{
  "namespace": "prompts",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_success",
    "echo_warning"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "QUESTION",
      "type": "str",
      "description": "A string containing the question.",
      "default": "Confirm ?"
    }
  ]
}
```

> Synopsis: _yes_no [QUESTION]<br>
>   QUESTION: (optional) A string containing the question. Defaults to "Confirm ?".<br>

### ⚡ Reflexion

#### 1. `_get_constants` (private)

List constants from provided shoe script

```json
{
  "namespace": "reflexion",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "GET_PRIVATE",
      "type": "bool",
      "description": "If set to \"true\", retrieves private constants as well.",
      "default": false
    }
  ]
}
```

> Synopsis: _get_constants &lt;SCRIPT_PATH&gt; [GET_PRIVATE]<br>
>   SCRIPT_PATH: The path to the input script.<br>
>   GET_PRIVATE: (Optional) If set to 'true', retrieves private constants as well. (default=false)<br>

#### 2. `_get_constraint` (private)

Get constaint for given variable from provided shoe script

```json
{
  "namespace": "reflexion",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "VARIABLE_NAME",
      "type": "str",
      "description": "The variable to validate.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_constraint &lt;SCRIPT_PATH&gt; &lt;VARIABLE_NAME&gt;<br>
>   SCRIPT_PATH:   The path to the input script.<br>
>   VARIABLE_NAME: The variable to validate.<br>

#### 3. `_get_flags` (private)

List flags from provided shoe script

```json
{
  "namespace": "reflexion",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_flags &lt;SCRIPT_PATH&gt;<br>
>   SCRIPT_PATH: The path to the input script.<br>

#### 4. `_get_function` (private)

Get function by name

```json
{
  "namespace": "reflexion",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "FUNCTION_NAME",
      "type": "str",
      "description": "The name of the function to retrieve.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_function &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;<br>
>   SCRIPT_PATH:   The path to the input file.<br>
>   FUNCTION_NAME: The name of the function to retrieve.<br>

#### 5. `_get_function_annotation` (private)

Get function annotation by name

```json
{
  "namespace": "reflexion",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "FUNCTION_NAME",
      "type": "str",
      "description": "The name of the function to retrieve.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_function_annotation &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;<br>
>   SCRIPT_PATH:   The path to the input file.<br>
>   FUNCTION_NAME: The name of the function to retrieve.<br>

#### 6. `_get_functions_names` (private)

List functions names from provided shoe script

```json
{
  "namespace": "reflexion",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "GET_PRIVATE",
      "type": "bool",
      "description": "If set to \"true\", retrieves private functions as well.",
      "default": false
    }
  ]
}
```

> Synopsis: _get_functions_names &lt;SCRIPT_PATH&gt; [GET_PRIVATE]<br>
>   SCRIPT_PATH: The path to the input script.<br>
>   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".<br>

#### 7. `_get_options` (private)

List options from provided shoe script

```json
{
  "namespace": "reflexion",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "GET_PRIVATE_ONLY",
      "type": "bool",
      "description": "If set to \"true\", retrieves private options only.",
      "default": false
    }
  ]
}
```

> Synopsis: _get_options &lt;SCRIPT_PATH&gt; [GET_PRIVATE_ONLY]<br>
>   SCRIPT_PATH:      The path to the input script.<br>
>   GET_PRIVATE_ONLY: (Optional) If set to 'true', retrieves private options only. Defaults to "false".<br>

#### 8. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script

```json
{
  "namespace": "reflexion",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_padding &lt;SCRIPT_PATH&gt;<br>
>   SCRIPT_PATH: The path to the input script.<br>

#### 9. `_get_parameter` (private)

Get value for given parameter from provided ".env" or ".sh" file

```json
{
  "namespace": "reflexion",
  "requires": [
    "sed"
  ],
  "depends": [
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "KEY",
      "type": "str",
      "description": "The variable name to get from provided file.",
      "nullable": false
    }
  ]
}
```

> Synopsys : _get_parameter &lt;FILE_PATH&gt; &lt;KEY&gt;<br>
>   FILE_PATH: The path to the input file.<br>
>   KEY:       The variable name to get from provided file.<br>

#### 10. `_parse_annotation` (private)

Return json object from annotation

```json
{
  "namespace": "reflexion",
  "requires": [
    "sed",
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "ANNOTATION",
      "type": "str",
      "description": "The input text containing raw annotation.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _parse_annotation &lt;ANNOTATION&gt;<br>
>   ANNOTATION: The input text containing raw annotation.<br>

#### 11. `_set_parameter` (private)

Set value for given parameter into provided file ".env" or ".sh" file

```json
{
  "namespace": "reflexion",
  "requires": [
    "sed"
  ],
  "depends": [
    "_sed_i",
    "echo_danger",
    "echo_info",
    "echo_warning"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "KEY",
      "type": "str",
      "description": "The variable name to get from provided file.",
      "nullable": false
    },
    {
      "position": 3,
      "name": "VALUE",
      "type": "str",
      "description": "The value to be set to provided file.",
      "nullable": false
    }
  ]
}
```

> Synopsys : _set_parameter &lt;FILE_PATH&gt; &lt;KEY&gt; &lt;VALUE&gt;<br>
>   FILE_PATH: The path to the input script.<br>
>   KEY:       The variable name to set to provided file<br>
>   VALUE:     The value to be set to provided file<br>

### ⚡ Strings

#### 1. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"

```json
{
  "namespace": "strings",
  "depends": [
    "_sed_i",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _collapse_blank_lines &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 2. `_generate_key` (private)

Generate random 32 bit string

```json
{
  "namespace": "strings",
  "requires": [
    "openssl"
  ],
  "depends": [
    "echo_info"
  ]
}
```

> Synopsis: _generate_key<br>

### ⚡ System

#### 1. `_check_installed` (private)

Print error message if provided command is missing

```json
{
  "namespace": "system",
  "depends": [
    "_get_package_name",
    "_is_installed",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "COMMAND",
      "type": "str",
      "description": "A string containing the command name to find.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _check_installed &lt;COMMAND&gt;<br>
>   COMMAND: A string containing the command name to find.<br>

#### 2. `_get_package_manager` (private)

Print default package manager

```json
{
  "namespace": "system",
  "depends": [
    "_is_installed",
    "echo_danger"
  ]
}
```

> Synopsis: _get_package_manager<br>

#### 3. `_get_package_name` (private)

Find package name for given command

```json
{
  "namespace": "system",
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "COMMAND",
      "type": "str",
      "description": "A string containing the command name to find.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _get_package_name &lt;COMMAND&gt;<br>
>   COMMAND: A string containing the command name to find.<br>

#### 4. `_is_checksum_valid` (private)

Validate a file checksum

```json
{
  "namespace": "system",
  "requires": [
    "awk",
    "sha256sum"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "FILE_PATH",
      "type": "file",
      "description": "The path to the input file.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "SHA256SUM",
      "type": "str",
      "description": "A string containing file checksum.",
      "nullable": false
    },
  ]
}
```

> Synopsis: _is_checksum_valid &lt;FILE_PATH&gt; &lt;SHA256SUM&gt;<br>
>   FILE_PATH: The path to the input file.<br>
>   SHA256SUM: A string containing file checksum.<br>

#### 5. `_is_gnome` (private)

Check current desktop is gnome

```json
{
  "namespace": "system",
  "assumes": [
    "XDG_CURRENT_DESKTOP"
  ]
}
```

> Synopsis: _is_gnome<br>

#### 6. `_is_installed` (private)

Check provided command is installed

```json
{
  "namespace": "system",
  "requires": [
    "dpkg"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "COMMAND",
      "type": "str",
      "description": "A string containing the command name to find.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _is_installed &lt;COMMAND&gt;<br>
>   COMMAND: A string containing the command name to find.<br>

#### 7. `_is_root` (private)

Check current user is root

```json
{
  "namespace": "system",
  "requires": [
    "awk",
    "id"
  ]
}
```

> Synopsis: _is_root<br>

#### 8. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally

```json
{
  "namespace": "system",
  "returns": "str"
}
```

> Synopsis: _pwd<br>

#### 9. `_remove` (private)

Remove given package from system

```json
{
  "namespace": "system",
  "requires": [
    "apt"
  ],
  "depends": [
    "_get_package_manager",
    "_get_package_name",
    "_is_installed",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "PACKAGE",
      "type": "str",
      "description": "The command/package to remove.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "PACKAGE_MANAGER",
      "type": "str",
      "description": "The package manager required to remove the package with.",
      "default": "apt"
    }
  ]
}
```

> Synopsis: _remove &lt;PACKAGE&gt; [PACKAGE_MANAGER]<br>
>   PACKAGE:         The command/package to remove.<br>
>   PACKAGE_MANAGER: (optional) The package manager required to remove the package with. Defaults to "apt".<br>
>   note:            eg: `_remove curl` will remove "curl" with "sudo apt remove --yes curl".<br>
>                    eg: `_remove adb android-tools-adb` will remove "android-tools-adb" package.<br>

#### 10. `_require` (private)

Install required package globally

```json
{
  "namespace": "system",
  "requires": [
    "apt"
  ],
  "depends": [
    "_get_package_manager",
    "_get_package_name",
    "_is_installed",
    "echo_danger",
    "echo_info"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "PACKAGE",
      "type": "str",
      "description": "The command/package to remove.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "PACKAGE_MANAGER",
      "type": "str",
      "description": "The package manager required to remove the package with.",
      "default": "apt"
    }
  ]
}
```

> Synopsis: _require &lt;PACKAGE&gt; [PACKAGE_MANAGER]<br>
>   PACKAGE:         The command/package to install.<br>
>   PACKAGE_MANAGER: (optional) The package manager required to install the package with.<br>
>   note:            eg: `_require curl` will install "curl" with "sudo apt install --yes curl".<br>
>                    eg: `_require adb` will install "android-tools-adb" package.<br>

#### 11. `_spin` (private)

Animate a spinner in the terminal for a given amout of time

```json
{
  "namespace": "system",
  "requires": [
    "awk"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "DURATION",
      "type": "int",
      "description": "Animation duration in miliseconds.",
      "default": 0
    }
  ]
}
```

> Synopsis: _spin [DURATION]<br>
>   DURATION: Animation duration in miliseconds<br>

#### 12. `_user_exists` (private)

Check provided user exists

```json
{
  "namespace": "system",
  "requires": [
    "awk"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "USERNAME",
      "type": "str",
      "description": "The username to check.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _user_exists [USERNAME]<br>
>   USERNAME: The username to check.<br>

### ⚡ Validation

#### 1. `_is_valid` (private)

Checks if variable is valid given regex constraint

```json
{
  "namespace": "validation",
  "requires": [
    "grep",
    "sed"
  ],
  "depends": [
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "VALUE",
      "type": "str",
      "description": "The string to be compared to regex pattern.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "PATTERN",
      "type": "str",
      "description": "The regex parttern to apply.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _is_valid &lt;VALUE&gt; &lt;PATTERN&gt;<br>
>   VALUE:   The string to be compared to regex pattern.<br>
>   PATTERN: The regex parttern to apply.<br>

#### 2. `_validate` (private)

Find constraints and validates a variable

```json
{
  "namespace": "validation",
  "requires": [
    "sed"
  ],
  "depends": [
    "_get_constraint",
    "_is_valid",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "VARIABLE",
      "type": "str",
      "description": "The variable to validate in the followling format : variable_name=value.",
      "nullable": false
    }
  ]
}
```

> Synopsis: _validate &lt;VARIABLE&gt;<br>
>   VARIABLE: The variable to validate in the followling format : variable_name=value.<br>

### ⚡ Kernel

#### 1. `_kernel` (private)

Shoe Kernel

```json
{
  "namespace": "kernel",
  "depends": [
    "_after",
    "_before",
    "_default",
    "_get_flags",
    "_get_functions_names",
    "_get_options",
    "_validate",
    "echo_danger"
  ]
}
```


