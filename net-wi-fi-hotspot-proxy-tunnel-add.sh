#!/bin/bash

# TODO: proxify DNS requests!

# DeepSeek explanation: 
# The problem is that simply redirecting traffic via REDIRECT doesn't work for SOCKS5, as SOCKS5 is a protocol, not a transparent proxy. REDIRECT in iptables only works for transparent proxies (usually HTTP), not for SOCKS5, which requires special handling.
# To solve this problem, you'll need an intermediate tool that can accept transparently redirected traffic and convert it to SOCKS5. The most popular option is redsocks.
# Or you can use tun2socks, which creates a virtual interface and routes traffic through it:
# https://github.com/xjasonlyu/tun2socks
# `go install github.com/xjasonlyu/tun2socks/v2@latest`

TUNNEL_ID="tun-hotspot-prx"
TABLE_ID=199
TUNNEL_SUBNET="10.199.0.0/24"
TUNNEL_IP="10.199.0.1"
HOTSPOT_SUBNET="10.42.0.0/24"
PROXY_PORT=10808
SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )
WI_FI_DEV="wlx503eaa78b4d2"

TUN_PATH=$(which tun2socks)

function cleanup_and_exit {
  echo "Cleaning..."
  set -x
  "$SCRIPT_DIR/net-wi-fi-hotspot-proxy-tunnel-remove.sh"
  exit
}

trap cleanup_and_exit EXIT INT TERM

sudo ip tuntap add mode tun dev $TUNNEL_ID
sudo ip addr add $TUNNEL_IP/24 dev "$TUNNEL_ID"
sudo ip link set dev "$TUNNEL_ID" up

sudo ip route add default via $TUNNEL_IP dev "$TUNNEL_ID" table $TABLE_ID
sudo ip route add $HOTSPOT_SUBNET dev "$WI_FI_DEV" table $TABLE_ID
sudo ip route add $TUNNEL_SUBNET dev $TUNNEL_ID table $TABLE_ID

sudo ip rule add iif "$WI_FI_DEV" table "$TABLE_ID"
sudo nft insert rule ip filter FORWARD iifname "$WI_FI_DEV" ip saddr $HOTSPOT_SUBNET accept

sudo "$TUN_PATH" --loglevel debug --device "$TUNNEL_ID" --proxy socks5://127.0.0.1:$PROXY_PORT
