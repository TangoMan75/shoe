#!/bin/sh

# Stop container stack with docker compose
#
# {
#   "namespace": "docker",
#   "depends": [
#     "_get_docker_compose",
#     "echo_info"
#   ]
# }
_docker_compose_stop() {
    # Synopsis: _docker_compose_stop

    echo_info "$(_get_docker_compose) stop\n"
    $(_get_docker_compose) stop
}

