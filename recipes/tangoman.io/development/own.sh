#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/development",
##   "summary": "Own project files",
##   "depends": [
##     "recipes/tangoman.io/database/_get_database_type",
##     "recipes/tangoman.io/docker/_own",
##     "src/shell/colors/_echo_error",
##     "src/shell/system/_is_root"
##   ],
##   "assumes": [
##     "USER",
##     "group",
##     "owner"
##   ]
## }
own() {
    if ! _is_root; then
        _echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    if [ -z "${owner}" ]; then
        owner=nobody
        group=nogroup
    else
        group="${owner}"
    fi

    for _file in \
        ./assets \
        ./bin \
        ./certs \
        ./logs \
        ./node_modules \
        ./var \
        ./vendor \
        ./volumes \
        .env.dev.local \
        .env.local \
        .env.prod.local \
        .php-cs-fixer.cache \
        composer.lock \
        symfony.lock \
        yarn.lock \
    ; do
        _own "${owner}" "${group}" "${_file}"
    done

    if [ "$(_get_database_type)" = sqlite ]; then
        for _file in \
            ./var/prod.db \
            ./var/dev.db \
            ./var/test.db \
        ; do
            _own "${owner}" "${group}" "${_file}"
        done
    fi
}

