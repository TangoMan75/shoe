#!/bin/sh

## Dump partition
##
## {
##   "namespace": "system",
##   "requires": [
##     "adb"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ]
## }
dump_partition() {
    _partition_name=boot_a
    _destination=/sdcard
    _filename="${_partition_name}.img"
    _partition="$(adb shell ls -l /dev/block/bootdevice/by-name | grep "${_partition_name}" | cut -d'>' -f2)"
    _partition="$(echo "${_partition}" | sed 's/ //')"

    if [ -z "${_partition}" ] && [ -z "${_destination}" ] && [ -z "${_filename}" ]; then
        _echo_error "could not dump \"${_partition}\" to \"${_destination}/${_filename}\""
        return 1
    fi

    _echo_info "adb shell dd if=\"${_partition}\" of=\"${_destination}/${_filename}\"\n"
    adb shell dd if="${_partition}" of="${_destination}/${_filename}"
}

