#!/bin/bash

TABLE_ID=199
TUNNEL_ID="tun-hotspot-prx"
WI_FI_DEV="wlx503eaa78b4d2"
HOTSPOT_SUBNET="10.42.0.0/24"

set -x

sudo nft -a list chain ip filter FORWARD
# sudo nft delete rule ip filter FORWARD handle НОМЕР
# sudo nft delete rule ip filter FORWARD iifname "$WI_FI_DEV" ip saddr $HOTSPOT_SUBNET/24 accept
# sudo nft delete rule ip filter FORWARD iifname "$WI_FI_DEV" mark set 1 
sudo ip rule del fwmark 1 table $TABLE_ID
# sudo nft delete rule ip filter FORWARD iifname "$WI_FI_DEV" ip saddr $HOTSPOT_SUBNET mark set 1 accept
HANDLE=$(sudo nft -a list chain ip filter FORWARD 2>/dev/null | grep -oP 'mark set 0x00000001.*# handle \K\d+')
if [ -n "$HANDLE" ]; then
    sudo nft delete rule ip filter FORWARD handle "$HANDLE"
fi
# Нельзя удалять
# sudo nft delete chain ip filter FORWARD
sudo nft -a list chain ip filter FORWARD

ip rule show table "$TABLE_ID"
sudo ip route flush table "$TABLE_ID"
{ set +x; } 2>/dev/null
sudo ip rule show | grep "lookup $TABLE_ID" | while read -r line; do
    PRIORITY=$(echo "$line" | awk -F: '{print $1}')
    sudo ip rule del priority $PRIORITY 2>/dev/null
done
set -x
ip rule show table "$TABLE_ID"

ip link show $TUNNEL_ID
sudo ip tuntap del mode tun dev $TUNNEL_ID
ip link show $TUNNEL_ID

