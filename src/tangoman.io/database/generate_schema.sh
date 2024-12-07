#!/bin/sh

## Generate schema from yaml (api-platform)
generate_schema() {
    echo_info "php -d memory-limit=-1 ./vendor/bin/schema generate \"$(pwd)/temp/\" ./config/schema.yaml\n"
    php -d memory-limit=-1 ./vendor/bin/schema generate "$(pwd)/temp/" ./config/schema.yaml
}

