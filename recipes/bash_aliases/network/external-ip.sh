#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/network",
##   "summary": "Get external IP",
##   "requires": [
##     "curl",
##     "echo",
##     "ip",
##     "wget"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger"
##   ]
## }
function external-ip() {
    #--------------------------------------------------
    # Check curl or wget installation
    #--------------------------------------------------

    if [ -z "$(command -v 'wget')" ] && [ -z "$(command -v 'curl')" ]; then
        _echo_danger 'error: curl not installed, try "sudo apt-get install -y curl"\n'
        return 1
    fi

    #--------------------------------------------------

    local ip

    #--------------------------------------------------

    ip="$(curl -s ipv4.icanhazip.com || wget -qO - ipv4.icanhazip.com)"
    if [ -z "${ip}" ]; then
        ip="$(curl -s api.ipify.org || wget -qO - api.ipify.org)\n"
    fi

    #--------------------------------------------------

    echo "${ip}"
}

