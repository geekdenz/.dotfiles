#!/usr/bin/env bash

# Works on Ubuntu 16.4

source "`dirname $0`/config.sh"

set -e

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.7/install.sh | bash
nvm install stable
