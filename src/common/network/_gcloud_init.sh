#!/bin/sh

# Configure gcloud
_gcloud_init() {
    # Synopsis: _gcloud_init

    _check_installed gcloud

    echo_info 'gcloud auth login\n'
    gcloud auth login

    echo_info 'gcloud auth configure-docker\n'
    gcloud auth configure-docker

    echo_info 'gcloud init\n'
    gcloud init
}

