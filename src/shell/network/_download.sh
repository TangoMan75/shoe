#!/bin/sh

## Downloads file with either curl or wget
##
## {
##   "namespace": "network",
##   "requires": [
##     "curl",
##     "grep",
##     "head",
##     "wget"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "_is_installed"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "URL",
##       "type": "str",
##       "description": "The URL of the file to download.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the output file.",
##       "nullable": false
##     }
##   ]
## }
_download() {
    # Synopsis: _download <URL> <FILE_PATH>
    #   URL:        The URL of the file to download.
    #   FILE_PATH:  The path to the output file.

    if [ -z "$1" ]; then _echo_error '_download: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_download: too many arguments ($#)\n"; return 1; fi

    # set default values
    set -- "$1" "${2:-"$0"}"
    # create destination folder
    if [ ! -d "$(dirname "$2")" ]; then _echo_info "mkdir -p \"$(dirname "$2")\"\n"; mkdir -p "$(dirname "$2")"; fi

    if _is_installed curl; then
        _echo_info "curl -sSLf \"$1\" -o \"$2\"\n"
        curl -sSLf "$1" -o "$2"

    elif _is_installed wget; then
        _echo_info "wget -q \"$1\" -O \"$2\"\n"
        wget -q "$1" -O "$2"

    else
        _echo_error 'Neither curl nor wget is available for downloading files.\n'

        return 1
    fi

    # Check if the downloaded file is valid (not empty and not an HTML error page)
    if [ ! -s "$2" ] || head -n 1 "$2" | grep -q "<!DOCTYPE html>"; then
        _echo_error 'Downloaded file is invalid or not found.\n'

        return 1
    fi
}

