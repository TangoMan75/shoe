#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/_tangoman",
##   "summary": "Print semantic color test",
##   "depends": [
##     "src/shell/colors/_alert_danger",
##     "src/shell/colors/_alert_dark",
##     "src/shell/colors/_alert_info",
##     "src/shell/colors/_alert_light",
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_alert_success",
##     "src/shell/colors/_alert_warning",
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_dark",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_light",
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_secondary",
##     "src/shell/colors/_echo_success",
##     "src/shell/colors/_echo_warning"
##   ]
## }
function tango-colors() {
    _alert_primary   '_alert_primary'
    _alert_secondary '_alert_secondary'
    _alert_success   '_alert_success'
    _alert_danger    '_alert_danger'
    _alert_warning   '_alert_warning'
    _alert_info      '_alert_info'
    _alert_light     '_alert_light'
    _alert_dark      '_alert_dark'
    _echo_primary   '_echo_primary\n'
    _echo_secondary '_echo_secondary\n'
    _echo_success   '_echo_success\n'
    _echo_danger    '_echo_danger\n'
    _echo_warning   '_echo_warning\n'
    _echo_info      '_echo_info\n'
    _echo_light     '_echo_light\n'
    _echo_dark      '_echo_dark\n'
    _echo_error     '_echo_error\n'
}

