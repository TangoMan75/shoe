#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

# shellcheck disable=SC2034

# PRIMARY: bright white text
PRIMARY='\033[97m'

# SECONDARY: bright blue text
SECONDARY='\033[94m'

# SUCCESS: bright green text
SUCCESS='\033[32m'

# DANGER: red text
DANGER='\033[31m'

# WARNING: orange text
WARNING='\033[33m'

# INFO: bright purple text
INFO='\033[95m'

# LIGHT: black text over white background
LIGHT='\033[47;90m'

# DARK: white text over black background
DARK='\033[40;37m'

# DEFAULT: reset formatting
DEFAULT='\033[0m'

# EOF: reset formatting and carriage return
EOL='\033[0m\n'

