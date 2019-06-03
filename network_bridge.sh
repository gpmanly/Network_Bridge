#!/bin/sh

# Set up transparent bridge eth1->eth0
#  - eth0 (built-in): attach to TT DSL router
#  - eth1 (USB)     : attach to internal switch
#
# This should be executed at system startup.
# On Raspberry PI debian add this line to:
# /etc/rc.local:
#   bash /path_to_this_file


# this requires the following:
#   apt-get install bridge-utils

echo "$0: setting eth0-eth1 bridge"

## shutdown everything first
ifconfig eth0 down
ifconfig eth1 down


## set interfaces to promiscuous mode
ifconfig eth0 0.0.0.0 promisc up
ifconfig eth1 0.0.0.0 promisc up

## add both interfaces to the virtual bridge network
brctl addbr br0
brctl addif br0 eth1
brctl addif br0 eth0

## optional: configure an ip to the bridge to allow remote access
#ifconfig br0 192.168.1.111 netmask 255.255.255.0 up
#route add default gw 192.168.1.1 dev br0
ifconfig br0 dhclient

echo "$0: done bridge"