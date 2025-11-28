#!/bin/bash

## Check commit hash is valid
##
## {
##   "namespace": "git",
##   "summary": "Check if a commit hash is valid.",
##   "parameters": [
##     {
##       "position": 1,
##       "name": "COMMIT",
##       "type": "str",
##       "description": "The commit hash to validate.",
##       "default": "",
##       "nullable": false
##     }
##   ]
## }
function _check_commit_is_valid() {
    if [[ "$1" =~ ^([0-9a-f]+|HEAD)(~[0-9]+)?$ ]]; then
        echo true
        return 0
    fi
    echo false
}

#--------------------------------------------------

# Parse commit type, eg: feat(foobar): FooBar (FOO-01) => feat
##
## {
##   "namespace": "git",
##   "summary": "Parse the commit type from a conventional commit message.",
##   "requires": [
##     "awk"
##   ],
##   "depends": [],
##   "assumes": [],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "COMMIT_MESSAGE",
##       "type": "str",
##       "description": "The conventional commit message to parse.",
##       "default": "",
##       "nullable": false
##     }
##   ]
## }
function _parse_commit_type() {
    echo -n "$1" | awk -F '[^a-z_]' '/^[a-z()_]*!?: /{print $1}'
}

# Parse commit scope, eg: feat(foobar): FooBar (FOO-01) => foobar
##
## {
##   "namespace": "git",
##   "summary": "Parse the commit scope from a conventional commit message.",
##   "requires": [
##     "awk",
##     "command"
##   ],
##   "depends": [
##     "_echo_danger"
##   ],
##   "assumes": [],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "COMMIT_MESSAGE",
##       "type": "str",
##       "description": "The conventional commit message to parse.",
##       "default": "",
##       "nullable": false
##     }
##   ]
## }
function _parse_commit_scope() {
    # Check awk installation
    if [ ! -x "$(command -v awk)" ]; then
        _echo_danger 'error: awk required, enter: "sudo apt-get install -y awk" to install\n'
        return 1
    fi

    echo -n "$1" | awk -F '[^a-z_-]' '/^[a-z()_-]*!?: /{print $2}'
}

# Parse commit subject, eg: feat(foobar): FooBar (FOO-01) => FooBar
##
## {
##   "namespace": "git",
##   "summary": "Parse the commit subject from a conventional commit message.",
##   "requires": [
##     "sed",
##     "tr"
##   ],
##   "depends": [],
##   "assumes": [],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "COMMIT_MESSAGE",
##       "type": "str",
##       "description": "The conventional commit message to parse.",
##       "default": "",
##       "nullable": false
##     }
##   ]
## }
function _parse_commit_subject() {
    # remove type ,scope, ticket and pull request from subject
    echo -n "$1" | sed -E 's/^[a-z()_]+!?: //' | sed -E 's/\([A-Z]+-[0-9]+\)//g' | sed -E 's/\(#\d+\)//g' | tr -s ' ' | sed -E 's/ +$//'
}

# Parse commit ticket, eg: feat(foobar): FooBar (FOO-01) => FOO-01
##
## {
##   "namespace": "git",
##   "summary": "Parse the ticket identifier from a conventional commit message.",
##   "requires": [
##     "sed"
##   ],
##   "depends": [],
##   "assumes": [],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "COMMIT_MESSAGE",
##       "type": "str",
##       "description": "The conventional commit message to parse.",
##       "default": "",
##       "nullable": false
##     }
##   ]
## }
function _parse_commit_ticket() {
    echo -n "$1" | sed -nE 's/.*\(([A-Z]+-[0-9]+)\).*/\1/p'
}

# Parse commit pull request, eg: feat(foobar): FooBar (FOO-01) (#4321) => 4321
##
## {
##   "namespace": "git",
##   "summary": "Parse the pull request number from a conventional commit message.",
##   "requires": [
##     "sed"
##   ],
##   "depends": [],
##   "assumes": [],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "COMMIT_MESSAGE",
##       "type": "str",
##       "description": "The conventional commit message to parse.",
##       "default": "",
##       "nullable": false
##     }
##   ]
## }
function _parse_commit_pull_request() {
    echo -n "$1" | sed -nE 's/.*\(#([0-9]+)\).*/\1/p'
}

#--------------------------------------------------

# Get commit type
##
## {
##   "namespace": "git",
##   "summary": "Get the commit type from the current HEAD commit.",
##   "requires": [
##     "git",
##     "command"
##   ],
##   "depends": [
##     "_echo_danger",
##     "_get_branch_type",
##     "_parse_commit_type"
##   ],
##   "assumes": [],
##   "parameters": []
## }
function _get_commit_type() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    local TYPE

    TYPE=$(_get_branch_type)
    if [ -n "${TYPE}" ]; then
        echo -n "${TYPE}"
        return 0
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_type "$(git --no-pager log -1 --pretty="format:%s")"
}

# Get commit scope
##
## {
##   "namespace": "git",
##   "summary": "Get the commit scope from the current HEAD commit.",
##   "requires": [
##     "git",
##     "command"
##   ],
##   "depends": [
##     "_echo_danger",
##     "_parse_commit_scope"
##   ],
##   "assumes": [],
##   "parameters": []
## }
function _get_commit_scope() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_scope "$(git --no-pager log -1 --pretty="format:%s")"
}

# Get commit subject
##
## {
##   "namespace": "git",
##   "summary": "Get the commit subject from the current HEAD commit.",
##   "requires": [
##     "git",
##     "command"
##   ],
##   "depends": [
##     "_echo_danger",
##     "_parse_commit_subject"
##   ],
##   "assumes": [],
##   "parameters": []
## }
function _get_commit_subject() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    # remove type and scope from subject
    _parse_commit_subject "$(git --no-pager log -1 --pretty="format:%s")"
}

# Get commit ticket
##
## {
##   "namespace": "git",
##   "summary": "Get the ticket identifier from the current HEAD commit.",
##   "requires": [
##     "git",
##     "command"
##   ],
##   "depends": [
##     "_echo_danger",
##     "_get_branch_ticket",
##     "_parse_commit_ticket"
##   ],
##   "assumes": [],
##   "parameters": []
## }
function _get_commit_ticket() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    local TICKET

    TICKET=$(_get_branch_ticket)
    if [ -n "${TICKET}" ]; then
        echo -n "${TICKET}"
        return 0
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_ticket "$(git --no-pager log -1 --pretty="format:%s")"
}

# Get commit pull request
##
## {
##   "namespace": "git",
##   "summary": "Get the pull request number from the current HEAD commit.",
##   "requires": [
##     "git",
##     "command"
##   ],
##   "depends": [
##     "_echo_danger",
##     "_parse_commit_pull_request"
##   ],
##   "assumes": [],
##   "parameters": []
## }
function _get_commit_pull_request() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_pull_request "$(git --no-pager log -1 --pretty="format:%s")"
}

# Get commit body
##
## {
##   "namespace": "git",
##   "summary": "Get the commit body from the current HEAD commit.",
##   "requires": [
##     "git",
##     "command"
##   ],
##   "depends": [
##     "_echo_danger",
##     "_trim"
##   ],
##   "assumes": [],
##   "parameters": []
## }
function _get_commit_body() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _trim "$(git --no-pager log -1 --pretty="format:%b")"
}
