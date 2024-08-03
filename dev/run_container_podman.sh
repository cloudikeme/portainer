#!/bin/bash
set -euo pipefail

PORTAINER_DATA=${PORTAINER_DATA:-/tmp/portainer}
PORTAINER_PROJECT=${PORTAINER_PROJECT:-$(pwd)}
PORTAINER_FLAGS=${PORTAINER_FLAGS:-}

podman rm -f portainer

podman run \
  -p 8000:8000 \
  -p 9000:9000 \
  -p 9443:9443 \
  -v "$PORTAINER_PROJECT/dist:/app" \
  -v "$PORTAINER_DATA:/data" \
  -v /var/run/podman/podman.sock:/var/run/docker.sock:Z \
  -v /var/run/podman/podman.sock:/var/run/alternative.sock:z \
  -v /tmp:/tmp \
  --log-level=DEBUG \
  --privileged \
  --restart=always \
  --name portainer \
  portainer/base \
  /app/portainer $PORTAINER_FLAGS


podman run \
    -p 8000:8000 \
    -p 9443:9443 \
    --name portainer \
    --restart=always \
    --privileged \
    -v /run/podman/podman.sock:/var/run/docker.sock:Z \
    -v portainer_data:/data \
    portainer/base \
    /app/portainer $PORTAINER_FLAGS
