#!/usr/bin/env bash

set -euo pipefail

containers=$(docker ps -q)

if [ -z "$containers" ]; then
  echo "No running containers found."
  exit 0
fi

for c in $containers; do
  name=$(docker inspect --format '{{.Name}}' "$c" | sed 's|/||')

  echo "=== Processing container: $name ($c) ==="

  if docker exec "$c" sh -c 'command -v apt-get >/dev/null 2>&1'; then
    docker exec "$c" sh -c '
      export DEBIAN_FRONTEND=noninteractive &&
      apt-get update &&
      apt-get upgrade -y
    '
    echo "✔ Upgraded $name"
  else
    echo "⚠ Skipping $name (apt-get not found)"
  fi

  echo
done
