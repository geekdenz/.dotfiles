#!/usr/bin/env bash

# Works on Ubuntu 16.4

source "`dirname $0`/config.sh"

set -e

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
nvm install --lts
