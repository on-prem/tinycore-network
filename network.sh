#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015-2016 Alexander Williams, Unscramble <license@unscramble.jp>

set -a

config="/usr/local/etc/network.conf"

/sbin/udevadm settle --timeout=5

if [ -f "$config" ]; then
  . $config

  if [ "$hostname" ]; then
    /usr/bin/sethostname $hostname
  fi

  /sbin/ifconfig $interface up
  echo "Waiting for interface $interface to be up"
  sleep 5

  case "$mode" in
    static)
      /opt/network_static.sh
      ;;
    dhcp)
      /opt/network_dhcp.sh
      ;;
  esac
else
  echo "Missing network config: $config"
  exit 1
fi

exit 0
