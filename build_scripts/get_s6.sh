#!/bin/bash -x

set +x

#TODO: Validate arguments

echo "Downloading and installing the s6-overlay ($2) 

case $1 in
  "linux/amd64")
    curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v$2/s6-overlay-amd64.tar.gz
    ;;
  "linux/arm/v7")
    curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v$2/s6-overlay-armhf.tar.gz
    ;;
  "linux/arm64")
    curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v$2/s6-overlay-aarch64.tar.gz
    ;;
  *)
    echo "unknown arch to get s6 overlay for"
    exit 1
    ;;
esac

if [ -f /tmp/s6-overlay.tar.gz ]; then
  tar xzf /tmp/s6-overlay.tar.gz -C /
  rm -f /tmp/s6-overlay.tar.gz
fi
