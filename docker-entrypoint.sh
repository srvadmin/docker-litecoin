#!/bin/bash
set -e

mkdir -p "$LITECOIN_DATA"

if [[ ! -s "$LITECOIN_DATA/litecoin.conf" ]]; then
    cat <<-EOF > "$LITECOIN_DATA/litecoin.conf"
		printtoconsole=1
		rpcallowip=::/0
    txindex=1
    testnet=${TESTNET:-0}
    rpcuser=${RPCUSER:-ltcuser}
    rpcpassword=${RPCPASSWORD:-saintpetersburg}
    rpcport=${RPCPORT:-2339}
		EOF
		chown litecoin:litecoin "$LITECOIN_DATA/litecoin.conf"
fi

# ensure correct ownership and linking of data directory
# we do not update group ownership here, in case users want to mount
# a host directory and still retain access to it
chown -R litecoin "$LITECOIN_DATA"
ln -sfn "$LITECOIN_DATA" /home/litecoin/.litecoin
chown -h litecoin:litecoin /home/litecoin/.litecoin

if [ $# -eq 0 ]; then
  exec gosu litecoin litecoind "$@"
else
  exec "$@"
fi
