#!/bin/sh

## Run installation script
##
## {
##   "namespace": "app",
##   "depends": [
##     "_alert_primary",
##     "_download",
##     "_echo_info",
##     "_extract",
##     "_move"
##   ],
##   "assumes": [
##     "APP_NAME",
##     "AUTHOR",
##     "INSTALL_DIRECTORY",
##     "TEMP_DIRECTORY",
##     "URL",
##     "VERSION"
##   ]
## }
install() {
    _alert_primary "Install ${AUTHOR} ${APP_NAME} v${VERSION}"

    _download "${URL}" "${TEMP_DIRECTORY}/${VERSION}.zip"
    _extract "${TEMP_DIRECTORY}/${VERSION}.zip"
    _move "${TEMP_DIRECTORY}/${APP_NAME}-${VERSION}/" "${INSTALL_DIRECTORY}/"

    _echo_info "rm -rf \"${TEMP_DIRECTORY}\"\n"
    rm -rf "${TEMP_DIRECTORY}"

    "${INSTALL_DIRECTORY}/${APP_NAME}.sh" self_install
}

install
