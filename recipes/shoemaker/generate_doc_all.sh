#!/bin/sh

## {
##   "namespace": "recipes/shoemaker",
##   "summary": "Generate Markdown documentation for all scripts",
##   "requires": [
##     "basename",
##     "find",
##     "mkdir"
##   ],
##   "depends": [
##     "src/shell/documentation/_generate_doc",
##     "src/shell/system/_pwd"
##   ]
## }
generate_doc_all() {
    doc_folder="$(_pwd)/doc"

    if [ ! -d "${doc_folder}" ]; then
        mkdir -p "${doc_folder}"
    fi

    find "$(_pwd)/build" -type f -name '*.sh' | while read -r file_path
    do
        _generate_doc "${file_path}" "${doc_folder}" "$(basename "${file_path}" .sh).md" "${private}"
    done
}

