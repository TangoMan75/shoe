#!/bin/sh

## Install git hooks
git_hooks() {
    echo_info "rm -fr \"${_project_directory}/.git/hooks\"\n"
    rm -fr "${_project_directory}/.git/hooks"

    echo_info "cp -r \"${_project_directory}/.githooks\" \"${_project_directory}/.git/hooks\"\n"
    cp -r "${_project_directory}/.githooks" "${_project_directory}/.git/hooks"

    echo_info "chmod +x \"${_project_directory}/.git/hooks/*\"\n"
    chmod +x "${_project_directory}/.git/hooks/*"
}

