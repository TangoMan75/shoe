#!/bin/sh

## Set /etc/hosts (local only)
hosts() {
    remove_hosts

    echo_info "cat <<<'EOT' | sudo tee -a /etc/hosts\n"
    cat <<EOT | sudo tee -a /etc/hosts
127.0.0.1 dev.tangoman.localhost
127.0.0.1 tangoman.localhost
EOT
    echo_info "EOT\n"
}

