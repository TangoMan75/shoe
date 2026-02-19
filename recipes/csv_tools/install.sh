#!/bin/sh

## Install tools
##
## {
##   "namespace": "install",
##   "requires": [
##     "python3"
##   ],
##   "depends": [
##     "alert_info"
##   ]
## }
install() {
    for FILE in \
        csv_to_json.py \
        json_to_csv.py \
        json_to_yaml.py \
        yaml_to_csv.py \
        yaml_to_json.py \
    ; do
        _echo_info "python3 \"${FILE}\" --install\n"
        python3 "${FILE}" --install
    done
}
