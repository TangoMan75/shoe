#!/bin/sh

## Import icons from FontAwesome
##
## {
##   "namespace": "app",
##   "requires": [
##     "curl"
##   ],
##   "depends": [
##     "_alert_primary",
##     "_import_icons"
##   ]
## }
import_icons() {
    _alert_primary 'Importing FontAwesome icons...'

    _import_icons brands "$(curl -s https://raw.githubusercontent.com/FortAwesome/Font-Awesome/refs/heads/6.x/css/brands.css)" > ./src/js/icons/brands.js
    _import_icons fontawesome "$(curl -s https://raw.githubusercontent.com/FortAwesome/Font-Awesome/refs/heads/6.x/css/fontawesome.css)" > ./src/js/icons/fontawesome.js
}
