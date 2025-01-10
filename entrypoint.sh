#!/bin/bash
set -meuo pipefail

if [ $# -eq 0 ]; then
  /zano/zano/build/src/zanod --rpc-bind-ip=0.0.0.0 --rpc-bind-port=11211
else
  exec "$@"
fi
