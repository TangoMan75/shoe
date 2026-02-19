#!/bin/sh

## Flash from current folder
flash_current_folder() {
    find . -maxdepth 1 -type f -name '*.img' | while read -r _file
    do
        _flash_img "${_file}" "$(basename "${file}" .img)"
    done
}

