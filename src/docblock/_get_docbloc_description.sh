#!/bin/sh

## Get docbloc description
_get_docbloc_description() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk '/^# \* @/ {i=2} /^#\/\*\*$/,/^# \*\/$/{i+=1; if (i>3) printf "%s ", substr($0, 5)}' "$0"
}

