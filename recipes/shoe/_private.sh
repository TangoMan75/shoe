#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

# Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.
_private() {
    echo "I'm private"
}

