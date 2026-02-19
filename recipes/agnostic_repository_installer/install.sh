#!/bin/sh

## {
##   "namespace": "recipes/agnostic_repository_installer",
##   "summary": "Run installation script",
##   "requires": [
##     "rm"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_echo_info",
##     "src/shell/files/_extract",
##     "src/shell/files/_move",
##     "src/shell/install/self_install",
##     "src/shell/network/_download"
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

