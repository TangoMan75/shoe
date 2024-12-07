#!/bin/sh

## Clear logs
clear() {
    echo_info 'rm -f ./logs/*.log || true\n'
    rm -f ./logs/*.log || true
}

