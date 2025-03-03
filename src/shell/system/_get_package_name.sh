#!/bin/sh

# Find package name for given command
#
# {
#   "namespace": "system",
#   "depends": [
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "COMMAND",
#       "type": "str",
#       "description": "A string containing the command name to find.",
#       "nullable": false
#     }
#   ]
# }
_get_package_name() {
    # Synopsis: _get_package_name <COMMAND>
    #   COMMAND: A string containing the command name to find.

    if [ -z "$1" ]; then echo_danger 'error: _get_package_name: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_package_name: too many arguments (${#})\n"; return 1; fi

    # debian packages
    if [ "$1" = aapt ];     then echo android-tools-adb;      return 0; fi
    if [ "$1" = adb ];      then echo android-tools-adb;      return 0; fi
    if [ "$1" = fastboot ]; then echo android-tools-fastboot; return 0; fi
    if [ "$1" = snap ];     then echo snapd;                  return 0; fi

    for __package__ in \
        arp \
        ifconfig \
        ipmaddr \
        iptunnel \
        mii-tool \
        nameif \
        plipconfig \
        rarp \
        route \
        slattach \
    ; do
        if [ "$1" = "${__package__}" ]; then
            echo net-tools

            return 0
        fi
    done

    echo "$1"
}

