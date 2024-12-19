#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

# Install git hooks
_git_hooks() {
    # Synopsis: _git_hooks

    if [ ! -d ./.githooks ]; then echo_danger "error: git_hooks: \"./.githooks\" folder not found\n"; return 1; fi

    echo_info "rm -fr \"./.git/hooks\"\n"
    rm -fr "./.git/hooks"

    echo_info "cp -r \"./.githooks\" \"./.git/hooks\"\n"
    cp -r "./.githooks" "./.git/hooks"

    echo_info "chmod +x \"./.git/hooks/*\"\n"
    chmod +x "./.git/hooks/*"
}

