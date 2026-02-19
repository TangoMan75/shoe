#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Generate schema from yaml (api-platform)",
##   "requires": [
##     "php",
##     "pwd"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
generate_schema() {
    if [ -f ./vendor/bin/schema ]; then
        _echo_info "php -d memory-limit=-1 ./vendor/bin/schema generate \"$(pwd)/src/\" ./config/schema.yaml\n"
        php -d memory-limit=-1 ./vendor/bin/schema generate "$(pwd)/src/" ./config/schema.yaml

        return 0
    fi

    if [ -x "$(command -v schema.phar)" ]; then
        _echo_info "schema.phar generate \"$(pwd)/src/\" ./config/schema.yaml\n"
        schema.phar generate "$(pwd)/src/" ./config/schema.yaml

        return 0
    fi

    _echo_error 'schema-generator executable not found\n'
    return 1
}

