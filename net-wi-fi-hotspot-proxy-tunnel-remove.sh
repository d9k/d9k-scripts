#!/bin/bash

TUNNEL_ID="tun-hotspot-prx"
TABLE_ID=199

set -x

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

