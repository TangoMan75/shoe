#!/bin/sh

## List the network adapters available on the system
##
## @namespace src/shell/network
## @requires arp awk command cut grep ifconfig ip iwconfig printf sed sort tr true uniq
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @flag <connected> [-c] Only list adapters with a connected peer.
## @flag <wifi> [-w] Only list wireless adapters.
## @flag <verbose> [-v] Print the command before execution.
_list_adapters() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-c' ]; then
            set -- "$@" '--connected'
            shift
        elif [ "$1" = '-w' ]; then
            set -- "$@" '--wifi'
            shift
        elif [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_list_adapters\n'
            _echo_success 'description:' 2 14; _echo_primary 'List network adapters\n'
            _echo_success 'usage:' 2 14; _echo_primary '_list_adapters -c (connected) -w (wifi) -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout:
    # $1: connected flag, $2: wifi flag, $3: verbose flag,
    # $4..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--wifi'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--connected'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--connected' ] || [ "$1" = '--wifi' ] \
            || [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 3 ]; then
        _echo_error "_list_adapters: too many arguments ($(( $# - 3 )))\n"

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$1" = 'true' ]; then
        if ! command -v arp >/dev/null 2>&1; then
            _echo_error '_list_adapters: arp required, try "sudo apt-get install -y net-tools"\n'

            return 1
        fi

        if [ "$2" = 'true' ]; then
            # $4: adapters, $5: display command.
            set -- "$1" "$2" "$3" \
                "$(arp -a \
                    | cut -d' ' -f7 \
                    | uniq \
                    | sort \
                    | sed -n 's/^\(w[[:alnum:]_]*\).*/\1/p' || true)" \
                "arp -a | cut -d' ' -f7 | uniq | sort | sed -n 's/^\(w[[:alnum:]_]*\).*/\1/p'"
        else
            set -- "$1" "$2" "$3" \
                "$(arp -a | cut -d' ' -f7 | uniq | sort)" \
                "arp -a | cut -d' ' -f7 | uniq | sort"
        fi
    elif [ "$2" = 'true' ]; then
        if ! command -v iwconfig >/dev/null 2>&1; then
            _echo_error '_list_adapters: iwconfig required, try "sudo apt-get install -y wireless-tools"\n'

            return 1
        fi

        set -- "$1" "$2" "$3" \
            "$(iwconfig 2>/dev/null \
                | awk '/^[[:alnum:]_]+/ \
                    && !/no wireless extensions/ {print $1}' \
                | sort || true)" \
            "iwconfig 2>/dev/null | awk '/^[[:alnum:]_]+/ && !/no wireless extensions/ {print \$1}' | sort"
    elif command -v ip >/dev/null 2>&1; then
        set -- "$1" "$2" "$3" \
            "$(ip token | cut -d' ' -f4 | sort)" \
            "ip token | cut -d' ' -f4 | sort"
    elif command -v ifconfig >/dev/null 2>&1; then
        set -- "$1" "$2" "$3" \
            "$(ifconfig \
                | sed -n 's/^\([[:alnum:]_-]*\).*/\1/p' | sort || true)" \
            "ifconfig | sed -n 's/^\([[:alnum:]_-]*\).*/\1/p' | sort"
    else
        _echo_error '_list_adapters: no network adapter utility found\n'

        return 1
    fi

    set -- "$1" "$2" "$3" \
        "$(printf '%s' "$4" | tr '\n' ' ' | sed -e 's/ *$//')" "$5"

    #--------------------------------------------------
    # Print result
    #--------------------------------------------------

    if [ "$3" = 'true' ]; then
        _echo_info "$5\n"
    fi

    printf '%s\n' "$4"
}

