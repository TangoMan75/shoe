#!/bin/sh

## {
##   "namespace": "src/shell/android",
##   "summary": "Check device is connected with fastboot",
##   "requires": [
##     "fastboot"
##   ],
##   "depends": [
##     "src/shell/system/_check_installed"
##   ]
## }
_is_device_connected_with_fastboot() {
    _check_installed fastboot

    if [ -z "$(fastboot devices)" ]; then

        return 1
    fi

    return 0
}

