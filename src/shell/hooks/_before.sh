#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

# Place here commands you need executed first every time (optional)
_before() {
    _check_installed awk
    _check_installed sed
}

