#!/bin/sh

## Update script from @update-link
self_update() {
    _update "$0" "$(_get_docbloc "$0" 'update-link')"
}

