#!/bin/sh

## The author of the repository.
AUTHOR=TangoMan75

## The name of the application being installed.
APP_NAME=agnostic-installer

## The GitHub repository path.
REPOSITORY="${AUTHOR}/${APP_NAME}"

## The version of the application to install.
VERSION=0.1.0

## The download URL for the application.
URL="https://github.com/${REPOSITORY}/archive/refs/tags/${VERSION}.zip"

## A temporary directory for downloads and extraction.
TEMP_DIRECTORY=$(mktemp -d)

## The final installation directory for the application.
INSTALL_DIRECTORY="${HOME}/.local/share/${REPOSITORY}"

