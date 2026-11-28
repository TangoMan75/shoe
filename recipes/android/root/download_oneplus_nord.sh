#!/bin/sh

## Download the files required to root a OnePlus Nord
##
## Downloads the pinned Magisk APK and the PitchBlack Recovery zip,
## then extracts "recovery.img" into the "recovery" option path.
## Existing files are kept as-is, so a custom Magisk build can be used.
##
## @namespace recipes/android/root
## @requires dirname rm unzip
## @depends src/shell/colors/_alert_info.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/network/_download.sh
## @depends src/shell/system/_is_checksum_valid.sh
## @assumes MAGISK_SHA256 MAGISK_VERSION PBRP_IMAGE_SHA256 PBRP_URL PBRP_VERSION PBRP_ZIP_SHA256 magisk_apk recovery
download_oneplus_nord() {
    _alert_info 'Downloading OnePlus Nord root files'

    if [ ! -f "${magisk_apk}" ]; then
        magisk_url="https://github.com/topjohnwu/Magisk/releases/download"
        magisk_url="${magisk_url}/${MAGISK_VERSION}"
        magisk_url="${magisk_url}/Magisk-${MAGISK_VERSION}.apk"

        _download "${magisk_url}" "${magisk_apk}" || {
            rm -f "${magisk_apk}"

            return 1
        }

        if ! _is_checksum_valid "${magisk_apk}" "${MAGISK_SHA256}"; then
            _echo_error "checksum mismatch: \"${magisk_apk}\"\n"
            rm -f "${magisk_apk}"

            return 1
        fi
    else
        _echo_info "using existing file: \"${magisk_apk}\"\n"
    fi

    if [ ! -f "${recovery}" ]; then
        pbrp_zip="$(dirname "${recovery}")"
        pbrp_zip="${pbrp_zip}/PBRP-avicii-${PBRP_VERSION}-OFFICIAL.zip"

        if [ ! -f "${pbrp_zip}" ]; then
            _download "${PBRP_URL}" "${pbrp_zip}" || {
                rm -f "${pbrp_zip}"

                return 1
            }
        else
            _echo_info "using existing file: \"${pbrp_zip}\"\n"
        fi

        if ! _is_checksum_valid "${pbrp_zip}" "${PBRP_ZIP_SHA256}"; then
            _echo_error "checksum mismatch: \"${pbrp_zip}\"\n"
            rm -f "${pbrp_zip}"

            return 1
        fi

        _echo_info "unzip -p \"${pbrp_zip}\" recovery.img > \"${recovery}\"\n"
        unzip -p "${pbrp_zip}" recovery.img > "${recovery}" || {
            rm -f "${recovery}"

            return 1
        }

        if ! _is_checksum_valid "${recovery}" "${PBRP_IMAGE_SHA256}"; then
            _echo_error "checksum mismatch: \"${recovery}\"\n"
            rm -f "${recovery}"

            return 1
        fi
    else
        _echo_info "using existing file: \"${recovery}\"\n"
    fi

    _echo_success 'root files ready\n'
}

