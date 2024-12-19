#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

# Set new host in /etc/hosts
_set_host() {
    # Synopsis: set_host <HOSTNAME>
    #   HOSTNAME:  The hostame to set locally.

    if [ -z "$1" ]; then echo_danger 'error: _set_host: some mandatory parameter is missing\n'; return 1; fi

    _remove_host "$1"

    echo_info "sudo /bin/sh -c \"echo \\\"127.0.0.1    $1\\\" >> /etc/hosts\"\n"
    sudo /bin/sh -c "echo \"127.0.0.1    $1\" >> /etc/hosts"
}

