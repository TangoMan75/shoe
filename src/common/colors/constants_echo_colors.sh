#!/bin/sh

# shellcheck disable=SC2034
{
    # PRIMARY:   bright white text
    # SECONDARY: bright blue text
    # SUCCESS:   bright green text
    # DANGER:    red text
    # WARNING:   orange text
    # INFO:      bright purple text
    # LIGHT:     black text over white background
    # DARK:      white text over black background

    PRIMARY='\033[97m'; SECONDARY='\033[94m'; SUCCESS='\033[32m'; DANGER='\033[31m'; WARNING='\033[33m'; INFO='\033[95m'; LIGHT='\033[47;90m'; DARK='\033[40;37m'; DEFAULT='\033[0m'; EOL='\033[0m\n'; 
}

