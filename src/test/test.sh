#!/bin/sh

## Execute test
test() {
    if _test1; then
        echo_success "success !\n"
    else
        echo_danger "failed !\n"
    fi

    if _test1b; then
        echo_success "success !\n"
    else
        echo_danger "failed !\n"
    fi

    if _test2; then
        echo_success "success !\n"
    else
        echo_danger "failed !\n"
    fi

    if _test2b; then
        echo_success "success !\n"
    else
        echo_danger "failed !\n"
    fi

}

_test1() {
    echo "_test1: should succeed."
    return 0
}

_test1b() {
    echo "_test1b: should fail."
    return 1
}

_test2() {
    echo "_test2: should exit with success status."
    exit 0
}

_test2b() {
    echo "_test2b: should exit with error status."
    exit 1
}

