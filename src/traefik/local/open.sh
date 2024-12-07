#!/bin/sh

## Open traefik and whoami dashboard in default browser
open() {

    if [ ! -f .env ]; then
        echo_error "\".env\" file not found\n"
        return 1
    fi

    # shellcheck disable=SC1090
    . "$(realpath .env)"

    for domain in ${DOMAINS}; do
        echo_info "nohup xdg-open \"http://${domain}.localhost\" >/dev/null 2>&1\n"
        nohup xdg-open "http://${domain}.localhost" >/dev/null 2>&1

        echo_info "nohup xdg-open \"https://${domain}.localhost\" >/dev/null 2>&1\n"
        nohup xdg-open "https://${domain}.localhost" >/dev/null 2>&1
    done

    echo_info 'nohup xdg-open http://traefik.localhost/api/rawdata >/dev/null 2>&1\n'
    nohup xdg-open http://traefik.localhost/api/rawdata >/dev/null 2>&1
}

