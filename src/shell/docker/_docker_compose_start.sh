#!/bin/sh

## {
##   "namespace": "src/shell/docker",
##   "summary": "Build and start container stack with docker compose",
##   "requires": [
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/docker/_get_docker_compose"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "description": "The path to the compose.yaml file.",
##       "type": "file"
##     },
##     {
##       "position": 2,
##       "name": "ENV_FILE",
##       "description": "The path to the env file.",
##       "type": "file"
##     }
##   ]
## }
_docker_compose_start() {
    if [ $# -gt 2 ]; then _echo_error "_docker_compose_start: too many arguments ($#)\n"; return 1; fi

    if [ $# -eq 2 ]; then
        if [ ! -f "$1" ]; then _echo_error "_docker_compose_start: \"$1\" file not found\n"; return 1; fi
        if [ ! -f "$2" ]; then _echo_error "_docker_compose_start: \"$2\" file not found\n"; return 1; fi
        set -- "$(realpath "$1")" "$(realpath "$2")"

        _echo_info "$(_get_docker_compose) --file \"$1\" --env-file \"$2\" up --detach --remove-orphans\n"
        $(_get_docker_compose) --file "$1" --env-file "$2" up --detach --remove-orphans

        return 0
    fi

    if [ $# -eq 1 ]; then
        if [ ! -f "$1" ]; then _echo_error "_docker_compose_start: \"$1\" file not found\n"; return 1; fi
        set -- "$(realpath "$1")"

        _echo_info "$(_get_docker_compose) --file \"$1\" up --detach --remove-orphans\n"
        $(_get_docker_compose) --file "$1" up --detach --remove-orphans

        return 0
    fi

    _echo_info "$(_get_docker_compose) up --detach --remove-orphans\n"
    $(_get_docker_compose) up --detach --remove-orphans
}

