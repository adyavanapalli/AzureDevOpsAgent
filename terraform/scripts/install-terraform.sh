#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o posix
set -o xtrace

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install terraform
