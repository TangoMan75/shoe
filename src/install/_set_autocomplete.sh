#!/bin/sh

## Create autocomplete script in install folder
_set_autocomplete(){
    # NOTE: check autocomplete tutorial here : https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial
    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_comspec)\" \"$(basename "$0" .sh)\" > \"$(dirname "$(realpath "$0")")/$(basename "$0" .sh)-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_comspec)" "$(basename "$0" .sh)" > "$(dirname "$(realpath "$0")")/$(basename "$0" .sh)-completion.sh"
}

