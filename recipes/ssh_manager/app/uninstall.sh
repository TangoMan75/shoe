#!/bin/sh

## Remove ssh keys and known_ssh_hosts from system
uninstall() {
    remove_ssh_identities
    remove_ssh
}
