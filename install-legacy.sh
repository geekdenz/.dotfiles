#!/usr/bin/env bash

# Compatibility entry point for old checkouts. Use the local installer only.
exec "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/install.sh"
