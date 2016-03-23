#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015-2016 Alexander Williams, Unscramble <license@unscramble.jp>

. /etc/init.d/tc-functions
set -a

config="/usr/local/etc/network.conf"

/sbin/udevadm settle --timeout=5

if [ -f "$config" ]; then
  . $config

  if [ "$hostname" ]; then
    /usr/bin/sethostname $hostname
  fi

  /sbin/ifconfig $interface up
  echo "${GREEN}Waiting for interface ${YELLOW}$interface${GREEN} to be up...${NORMAL}"
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
  echo "${RED}Missing network config: ${YELLOW}${config}${NORMAL}"
  exit 1
fi

exit 0
