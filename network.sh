#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015 Alexander Williams, Unscramble <license@unscramble.jp>

set -a

config="/usr/local/etc/network.conf"

if [ -f "$config" ]; then
  . $config

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
