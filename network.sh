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
    echo -n "${GREEN}Setting hostname to ${MAGENTA}$hostname${NORMAL}"
    sed -i "/^127.0.0.1/c\127.0.0.1 $hostname localhost localhost.local" /etc/hosts
    echo "$hostname" > /etc/hostname
    hostname "$hostname"
    echo "${GREEN} Done.${NORMAL}"
  fi

  /sbin/ifconfig $interface up
  echo -n "${GREEN}Waiting for interface ${MAGENTA}$interface${GREEN} to be up...${NORMAL}"
  sleep 5
  echo "${GREEN} Done.${NORMAL}"

  case "$mode" in
    static)
      /opt/network_static.sh
      ;;
    dhcp)
      /opt/network_dhcp.sh
      ;;
  esac
else
  echo "${RED}Missing network config: ${RED}${config}${NORMAL}"
  exit 1
fi

exit 0
