#!/bin/sh

## Dump app assets
assetic() {
    echo_info "./bin/console assetic:dump --env=\"${env}\"\n"
    ./bin/console assetic:dump --env="${env}"
}

