#!/bin/sh

## Source file /^~?[a-zA-Z0-9/._-]+$/
file=''

## Source directory /^~?[a-zA-Z0-9/._-]+$/
source=.

## Destination directory /^~?[a-zA-Z0-9/._-]+$/
destination=.

## Remote directory /^~?[a-zA-Z0-9/._-]+$/
remote=/data/media

## vbmeta file path /^~?[a-zA-Z0-9/._-]+$/
vbmeta=./oneplus_nord/vbmeta.img

## recovery file path /^~?[a-zA-Z0-9/._-]+$/
recovery=./oneplus_nord/PBRP-avicii-4.0-20251015-1636.img

## System IMG file path /^~?[a-zA-Z0-9/._-]+$/
system=./system.zip

## Magisk APK file path /^~?[a-zA-Z0-9/._-]+$/
magisk_apk=./oneplus_nord/Magisk-v27.0.apk

## Boot partition backup directory /^~?[a-zA-Z0-9/._-]+$/
backup_dir=./oneplus_nord/backup

## Device local IP address /^([0-9]{1,3}\.){3}[0-9]{1,3}$/
ip=192.168.0.1

## Device connection port /^[0-9]{1,5}$/
port=55555

## apk to remove from device /^[a-zA-Z0-9/._-]+$/
apk_name=''

