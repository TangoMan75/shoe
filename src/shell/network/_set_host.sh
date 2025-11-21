#!/bin/sh

# Set new host in /etc/hosts
#
# {
#   "namespace": "network",
#   "depends": [
#     "_remove_host",
#     "echo_danger",
#     "echo_info"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "HOSTNAME",
#       "type": "str",
#       "description": "The hostame to set locally.",
#       "nullable": false
#     }
#   ]
# }
_set_host() {
    # Synopsis: set_host <HOSTNAME>
    #   HOSTNAME: The hostame to set locally.

    if [ -z "$1" ]; then echo_danger 'error: _set_host: some mandatory parameter is missing\n'; return 1; fi

    _remove_host "$1"

    echo_info "sudo /bin/sh -c \"echo \\\"127.0.0.1    $1\\\" >> /etc/hosts\"\n"
    sudo /bin/sh -c "echo \"127.0.0.1    $1\" >> /etc/hosts"
}

