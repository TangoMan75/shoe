#!/bin/sh

## Import icons from FontAwesome
##
## {
##   "namespace": "app",
##   "requires": [
##     "bash",
##     "echo",
##     "grep",
##     "printf",
##     "sort"
##   ]
## }
_import_icons() {
    name="$1"
    icons=$(echo "$2" | grep -oP 'fa-[a-zA-Z0-9-]+' | sort -u)
    exclude_icons="fa-0 fa-1 fa-10x fa-1x fa-2 fa-2x fa-2xl fa-2xs fa-3 fa-3x fa-4 fa-4x fa-5 fa-5x fa-6 fa-6x fa-7 fa-7x fa-8 fa-8x fa-9 fa-9x fa-animation-delay fa-animation-direction fa-animation-duration fa-animation-iteration-count fa-animation-timing fa-beat fa-beat-fade fa-beat-fade-opacity fa-beat-fade-scale fa-beat-scale fa-border fa-border-color fa-border-padding fa-border-radius fa-border-style fa-border-width fa-bounce fa-bounce-height fa-bounce-jump-scale-x fa-bounce-jump-scale-y fa-bounce-land-scale-x fa-bounce-land-scale-y fa-bounce-rebound fa-bounce-start-scale-x fa-bounce-start-scale-y fa-brands fa-classic fa-display fa-fade fa-fade-opacity fa-flip fa-flip-angle fa-flip-both fa-flip-horizontal fa-flip-vertical fa-flip-x fa-flip-y fa-flip-z fa-fw fa-inverse fa-level-up-alt fa-lg fa-li fa-li-margin fa-li-width fa-pull-left fa-pull-margin fa-pull-right fa-pulse fa-regular fa-rotate-180 fa-rotate-270 fa-rotate-90 fa-rotate-angle fa-rotate-by fa-shake fa-sm fa-solid fa-spin fa-spin-pulse fa-spin-reverse fa-sr-only fa-sr-only-focusable fa-stack fa-stack-1x fa-stack-2x fa-stack-z-index fa-style fa-style-family fa-ul fa-xl fa-xs"

    filtered_icons=()
    for icon in ${icons}; do
        # shellcheck disable=SC2076
        if [[ ! "${exclude_icons}" =~ "${icon} " ]]; then
            filtered_icons+=("$icon")
        fi
    done

    json=$(printf "  \"%s\",\n" "${filtered_icons[@]}")

    echo -e "export const ${name} = [\n${json%,}\n];"
}
