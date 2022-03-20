#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o posix
set -o xtrace

sudo apt-get update
sudo apt-get install libssl-dev libffi-dev python-dev

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
