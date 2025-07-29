#!/bin/bash

# Present user with a list of choices and prompt them to select one
_select() {
    # Synopsis: _select <CHOICES>
    #   CHOICES:  Array containing choices

    if [ -z "$1" ]; then echo_danger 'error: _select: some mandatory parameter is missing\n'; return 1; fi

    PS3=$(echo_success 'Please select your choice : ')
    select __select__ in "$@"; do
        # validate selection
        for __item__ in "$@"; do
            # find selected container
            if [[ "${__item__}" == "${__select__}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    echo "${__item__}"
}

