#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o posix
set -o xtrace

# main () {
#     AGENT_DIRECTORY="$1"
#     TOKEN="$2"
#     URL="$3"

#     if [ ! -d "$AGENT_DIRECTORY" ]; then
#         mkdir "$AGENT_DIRECTORY"

#         wget --output-document - "https://vstsagentpackage.azureedge.net/agent/2.200.2/vsts-agent-linux-x64-2.200.2.tar.gz" | \
#         tar --extract --gzip --verbose --directory="$AGENT_DIRECTORY"

#         cd "$AGENT_DIRECTORY"

#         ./config.sh --token="$TOKEN" --unattended --url="$URL"

#         sudo ./svc.sh install
#         sudo ./svc.sh start

#         sleep 5

#         sudo ./svc.sh uninstall
#         ./config.sh remove --unattended --token="$TOKEN"
#     fi
# }

echo "$@"
# main "$@"
