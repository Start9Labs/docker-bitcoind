#!/bin/bash

set -euo pipefail

ip -4 route list match 0/0 | awk '{print $3 "\thost.docker.internal"}' >> /etc/hosts

BITCOIN_DIR=/root/.bitcoin
BITCOIN_CONF=${BITCOIN_DIR}/bitcoin.conf
HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')

# If config doesn't exist, initialize with sane defaults for running a
# non-mining node.
/root/tera -f /root/.bitcoin/bitcoin.conf.template --yaml /root/config.yaml
echo "HOST IP: ${HOST_IP}"

exec bitcoind -datadir=${BITCOIN_DIR} -proxy=${HOST_IP}:9050 -externalip=${TOR_ADDRESS} -conf=${BITCOIN_CONF}
