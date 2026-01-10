
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
