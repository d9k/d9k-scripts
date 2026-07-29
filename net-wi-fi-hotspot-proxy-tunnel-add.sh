#!/bin/bash

TUNNEL_ID="tun-hotspot-prx"
TABLE_ID=199
# TUNNEL_SUBNET="10.199.0.0"
TUNNEL_SUBNET="10.199.0.0"
TUNNEL_IP="10.199.0.1"
HOTSPOT_SUBNET="10.42.0.0"
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
sudo ip route add $HOTSPOT_SUBNET/24 dev "$WI_FI_DEV" table $TABLE_ID
sudo ip route add $TUNNEL_SUBNET/24 dev $TUNNEL_ID table $TABLE_ID

sudo ip rule add from $HOTSPOT_SUBNET/24 table $TABLE_ID

# Маркировка форвард-пакетов от хотспота
sudo nft add rule ip filter FORWARD iifname "$WI_FI_DEV" mark set 1

# Правило для маркированных пакетов
sudo ip rule add fwmark 1 table $TABLE_ID

# Проблема в том, что мы добавили mark set 1 в FORWARD, но до того, как пакет принимается в FORWARD, он должен пройти цепочку nm-sh-fw-wlx503eaa78b4d2, где разрешены только пакеты ct state related,established и от 10.42.0.0/24
sudo nft insert rule ip filter FORWARD mark 1 accept

# Удалить старое правило from (если есть)
sudo ip rule del from $HOTSPOT_SUBNET/24 table $TABLE_ID 2>/dev/null

sudo "$TUN_PATH" -device "$TUNNEL_ID" -proxy socks5://127.0.0.1:$PROXY_PORT
