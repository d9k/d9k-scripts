#!/bin/bash

# TUNNEL_ID="tun-hotspot-proxy-199"
TUNNEL_ID="tun-hotspot-prx"
TABLE_ID=199
TUNNEL_SUBNET="10.199.0.0"
HOTSPOT_SUBNET="10.42.0.0"
PROXY_PORT=10808
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

sudo ip tuntap add mode tun dev $TUNNEL_ID
sudo ip addr add $TUNNEL_SUBNET/24 dev "$TUNNEL_ID"
sudo ip link set dev "$TUNNEL_ID" up

sudo ip route add default via $TUNNEL_SUBNET dev "$TUNNEL_ID" table $TABLE_ID
sudo ip rule add from $HOTSPOT_SUBNET/24 table $TABLE_ID

TUN_PATH=$(which tun2socks)

function cleanup_and_exit {
  echo "Cleaning..."
  set -x
  "$SCRIPT_DIR/net-wi-fi-hotspot-proxy-tunnel-remove.sh"
  exit
}

trap cleanup_and_exit EXIT INT TERM

sudo "$TUN_PATH" -device "$TUNNEL_ID" -proxy socks5://127.0.0.1:$PROXY_PORT


