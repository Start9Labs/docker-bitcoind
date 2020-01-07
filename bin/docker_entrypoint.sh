#!/bin/bash

set -euo pipefail

ip -4 route list match 0/0 | awk '{print $3 "\thost.docker.internal"}' >> /etc/hosts

BITCOIN_DIR=/root/.bitcoin
BITCOIN_CONF=${BITCOIN_DIR}/bitcoin.conf
HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')

# If config doesn't exist, initialize with sane defaults for running a
# non-mining node.
/root/tmpl /root/config.yaml < ${BITCOIN_DIR}/bitcoin.conf.template > ${BITCOIN_CONF}
echo "HOST IP: ${HOST_IP}"
echo "TorAddress ${HOST_IP}" > /etc/tor/torsocks.conf
echo "TorPort 9050" >> /etc/tor/torsocks.conf
echo "OnionAddrRange 127.42.42.0/24" >> /etc/tor/torsocks.conf
echo "AllowInbound 1" >> /etc/tor/torsocks.conf

exec torsocks bitcoind -datadir=${BITCOIN_DIR} -externalip=${TOR_ADDRESS} -conf=${BITCOIN_CONF}
