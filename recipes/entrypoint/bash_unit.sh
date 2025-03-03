#!/bin/sh

## Install bash_unit framework
##
## {
##   "requires": [
##     "curl"
##   ],
##   "depends": [
##     "_check_installed",
##     "echo_danger",
##     "echo_info"
##   ]
## }
bash_unit() {
    if [ ! -d ./tests ]; then
        mkdir -p ./tests

    cat > "./tests/test_sample.sh" <<EOF
#!/bin/bash
# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world
test_can_fail() {
    fail "You need to write some tests"
}
EOF
    fi

    if [ ! -f "./tests/bash_unit" ]; then
        if [ -x "$(command -v wget)" ]; then
            echo_info "wget -qO \"./tests/bash_unit\" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit\n"
            wget -qO "./tests/bash_unit" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit

        elif [ -x "$(command -v curl)" ]; then
            echo_info "curl -sSL -o \"./tests/bash_unit\" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit\n"
            curl -sSL -o "./tests/bash_unit" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit

        else
            echo_danger "error: could not find \"bash_unit\" executable, please install manually\n"
            exit 1
        fi
    fi

    if [ ! -x "./tests/bash_unit" ]; then
        echo_info "chmod +x \"./tests\"/bash_unit\n"
        chmod +x ./tests/bash_unit
    fi
}

