#!/bin/sh

## Dump app assets
assetic() {
    _echo_info "./bin/console assetic:dump --env=\"${env}\"\n"
    ./bin/console assetic:dump --env="${env}"
}

