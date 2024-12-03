#!/bin/sh

## Print app status
status() {
    # echo_info "docker inspect --format='{{index .Config.Labels "com.docker.compose.project.config_files"}}' $(docker ps --all --quiet)\n"
    # # shellcheck disable=SC2046
    # docker inspect --format='{{index .Config.Labels "com.docker.compose.project.config_files"}}' $(docker ps --all --quiet)

    echo_info "docker inspect --format '{{slice .ID 0 13}} {{slice .Name 1}} {{index .Config.Labels \"com.docker.compose.project.config_files\"}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range \$p, \$c := .NetworkSettings.Ports}}{{\$p}} {{end}}' \$(docker ps --all --quiet) | column -t\n"
    # shellcheck disable=SC2046
    docker inspect --format '{{slice .ID 0 13}} {{slice .Name 1}} {{index .Config.Labels "com.docker.compose.project.config_files"}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range $p, $c := .NetworkSettings.Ports}}{{$p}} {{end}}' $(docker ps --all --quiet) | column -t
}

