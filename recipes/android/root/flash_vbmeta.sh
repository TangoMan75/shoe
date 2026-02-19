#!/bin/sh

## Flash vbmeta (Disable boot verification-AVB fix bootloop)
flash_vbmeta() {
    _flash_img "${vbmeta}" vbmeta
}

