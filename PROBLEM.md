I am trying to run a bitcoind node through a *manually configured* tor hidden service and I am getting the following error:
```
Error: Cannot resolve -externalip address: 'btbiujgpxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxrx2q42yd.onion'
```

The configuration of the system is as follows:
  * host (debian buster) is running tor, with the socks5 proxy running on 0.0.0.0:9050
  * dockerd (on host) is running a bitcoind container (https://github.com/Start9Labs/docker-bitcoind (based on `jamesob`'s image))
  * ports 8332 and 8333 are exposed from the docker container
  * a hidden service is setup in /etc/tor/torrc for ports 8332 and 8333
  * bitcoin.conf is configured as follows:
```
bind=0.0.0.0:8333
listen=1
rpcbind=0.0.0.0:8332
rpcuser={{rpcuser}}
rpcpassword={{rpcpassword}}
rpcallowip=0.0.0.0/0

```
  * bitcoin is being run with the following command (all env vars specified are available):
```
bitcoind -proxy="${HOST_IP}:9050" -onion="${HOST_IP}:9050" -externalip="${TOR_ADDRESS}" -datadir=${BITCOIN_DIR} -conf=${BITCOIN_CONF}
```
