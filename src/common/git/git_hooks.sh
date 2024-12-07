#!/bin/sh

## Install git hooks
git_hooks() {
    if [ ! -d ./.githooks ]; then echo_danger "error: git_hooks: \"./.githooks\" folder not found\n"; return 1; fi

    echo_info "rm -fr \"./.git/hooks\"\n"
    rm -fr "./.git/hooks"

    echo_info "cp -r \"./.githooks\" \"./.git/hooks\"\n"
    cp -r "./.githooks" "./.git/hooks"

    echo_info "chmod +x \"./.git/hooks/*\"\n"
    chmod +x "./.git/hooks/*"
}

