#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

function docker_tf () {
    local EXTRA_ARGS=""
    local REPO_ROOT="$( cd "$(dirname "$0")" ; pwd -P )"
    local TF_VERSION="1.4.6"
    local TF_DOCKER_NAME="hashicorp/terraform:${TF_VERSION}"
    
    if [ $(docker image ls -q ${TF_DOCKER_NAME} | wc -l) -lt 1 ]; then
        docker pull ${TF_DOCKER_NAME}
    fi

    docker run -i --rm \
        --volume "$REPO_ROOT:/terraform-data-dir" \
        --volume "$HOME/.aws:/root/.aws" \
        -w "/terraform-data-dir/${TF_ENVIRONMENT_CONF}" \
        ${EXTRA_ARGS} \
        ${TF_DOCKER_NAME} "$@"
}
