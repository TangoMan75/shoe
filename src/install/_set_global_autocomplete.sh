#!/bin/sh

## Create autocomplete script in /etc/bash_completion.d/
_set_global_autocomplete(){
    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_comspec)\" \"$(basename "$0" .sh)\" | sudo tee \"/etc/bash_completion.d/$(basename "$0" .sh)\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_comspec)" "$(basename "$0" .sh)" | sudo tee "/etc/bash_completion.d/$(basename "$0" .sh)"
}

