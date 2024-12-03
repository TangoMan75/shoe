#!/bin/sh








































## Generate Markdown documentation
generate_doc() {
    alert_primary "Generating $(basename "${0}" .sh) documentation"

    _documentation_path="$(realpath "$(basename "${0}" .sh).md")"
    _generate_doc > "${_documentation_path}"
    echo_success "Documentation generated in : \"${_documentation_path}\"\n"
}


































