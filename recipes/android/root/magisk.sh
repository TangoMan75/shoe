#!/bin/sh

## Push Magisk and no-verify-opt-encrypt to phone
magisk() {
    # NOTE: `adb sideload` method does not work
    # no-verity-opt-encrypt is used to prevent changes to the system partition from being detected by Android’s verified boot feature.
    for file in \
        magisk-v23.0.zip \
        no-verity-opt-encrypt-6.1.zip \
    ; do
        push "${file}"
    done
}

