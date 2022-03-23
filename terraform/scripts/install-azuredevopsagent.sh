#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o posix
set -o xtrace

main () {
    AGENT_DIRECTORY="$1"
    AGENT_DOWNLOAD_URL="$2"
    AGENT_PAT="$3"
    URL="$4"

    if [ ! -d "$AGENT_DIRECTORY" ]; then
        runuser adyavanapalli --command="
            mkdir $AGENT_DIRECTORY

            wget --output-document - $AGENT_DOWNLOAD_URL | tar --extract --gzip --verbose --directory=$AGENT_DIRECTORY

            cd $AGENT_DIRECTORY
            ./config.sh --token=$AGENT_PAT --unattended --url=$URL
        "

        cd "$AGENT_DIRECTORY"

        ./svc.sh install
        ./svc.sh start
    fi
}

main "$@"
