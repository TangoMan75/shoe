#!/bin/sh

## Configure gcloud
gcloud_init() {
    echo_info 'gcloud auth login\n'
    gcloud auth login

    echo_info 'gcloud auth configure-docker\n'
    gcloud auth configure-docker

    echo_info 'gcloud init\n'
    gcloud init
}

