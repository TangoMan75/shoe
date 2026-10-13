#!/bin/sh

## {
##   "namespace": "src/shell/network",
##   "summary": "Set new host in /etc/hosts",
##   "requires": [
##     "sudo"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/network/_remove_host"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "HOSTNAME",
##       "type": "str",
##       "description": "The hostame to set locally.",
##       "nullable": false
##     }
##   ]
## }
_set_host() {
    # Synopsis: _set_host <HOSTNAME>
    #   HOSTNAME: The hostame to set locally.

    if [ -z "$1" ]; then _echo_error '_set_host: some mandatory parameter is missing\n'; return 1; fi

    _remove_host "$1"

    _echo_info "sudo /bin/sh -c \"echo \\\"127.0.0.1    $1\\\" >> /etc/hosts\"\n"
    sudo /bin/sh -c "echo \"127.0.0.1    $1\" >> /etc/hosts"
}
