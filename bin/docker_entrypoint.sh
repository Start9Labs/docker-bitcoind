#!/bin/bash

set -euo pipefail

ip -4 route list match 0/0 | awk '{print $3 "\thost.docker.internal"}' >> /etc/hosts

BITCOIN_DIR=/root/.bitcoin
BITCOIN_CONF=${BITCOIN_DIR}/bitcoin.conf

# If config doesn't exist, initialize with sane defaults for running a
# non-mining node.

if [ $# -eq 0 ]; then
  exec bitcoind -datadir=${BITCOIN_DIR} -conf=${BITCOIN_CONF}
else
  exec "$@"
fi
