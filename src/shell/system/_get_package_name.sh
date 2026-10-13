#!/bin/sh

## {
##   "namespace": "src/shell/system",
##   "summary": "Find package name for given command",
##   "requires": [
##     "echo",
##     "snap"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "COMMAND",
##       "description": "A string containing the command name to find.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_get_package_name() {
    if [ -z "$1" ]; then _echo_error '_get_package_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_package_name: too many arguments ($#)\n"; return 1; fi

    # debian packages
    if [ "$1" = aapt ];     then echo android-tools-adb;      return 0; fi
    if [ "$1" = adb ];      then echo android-tools-adb;      return 0; fi
    if [ "$1" = fastboot ]; then echo android-tools-fastboot; return 0; fi
    if [ "$1" = snap ];     then echo snapd;                  return 0; fi

    for __package__ in \
        ab \
        check_forensic \
        checkgid \
        fcgistarter \
        htcacheclean \
        htdbm \
        htdigest \
        htpasswd \
        httxt2dbm \
        logresolve \
        rotatelogs \
        split-logfile \
    ; do
        if [ "$1" = "${__package__}" ]; then
            echo apache2-utils

            return 0
        fi
    done

    for __package__ in \
        certutil \
        modutil \
        pk12util \
        shlibsign \
        signtool \
        ssltap \
    ; do
        if [ "$1" = "${__package__}" ]; then
            echo libnss3-tools

            return 0
        fi
    done

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
