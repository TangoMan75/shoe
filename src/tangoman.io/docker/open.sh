#!/bin/sh

## Open container in default browser
open() {
    _container_name="$(container_name nginx)"
    _container_ip="$(container_ip "${_container_name}")"

    echo_info "nohup xdg-open \"http://${_container_ip}\" >/dev/null 2>&1\n"
    nohup xdg-open "http://${_container_ip}" >/dev/null 2>&1
}

