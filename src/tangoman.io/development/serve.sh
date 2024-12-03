#!/bin/sh

## Serve locally with PHP or Symfony
serve() {
    if [ -x "$(command -v symfony)"  ]; then
        echo_info "symfony serve --port=${port} --no-tls\n"
        symfony serve --port=${port} --no-tls
    else
        echo_info "php -d memory-limit=-1 -S 127.0.0.1:${port} -t ./public\n"
        php -d memory-limit=-1 -S 127.0.0.1:${port} -t ./public
    fi
}

