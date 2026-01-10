
```bash
#!/bin/bash

# --- Configuration ---
THRESHOLD=$1
TOPIC='SECRET'
HOSTNAME=$(hostname)

# --- Check Disk Usage for the root filesystem (/) ---
# Extracts the usage percentage as a number
USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# --- Send Alert if threshold is exceeded ---
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    SUBJECT="Alert: High Disk Usage on $HOSTNAME - $USAGE%"
    BODY="Warning: Disk usage on $HOSTNAME is currently at ${USAGE}%."

    curl -d "$SUBJECT - $BODY" ntfy.sh/$TOPIC
fi
```

### Run apt-get update && apt-get upgrade -y on Docker Containers

```bash
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
```
