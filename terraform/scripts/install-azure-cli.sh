#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o posix
set -o xtrace

curl -sL https://aka.ms/InstallAzureCLI | sudo bash
