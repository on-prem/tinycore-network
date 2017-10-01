#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015-2017 Alexander Williams, Unscramble <license@unscramble.jp>

. /etc/init.d/tc-functions
set -a

config="/usr/local/etc/network.conf"
ntp_tries=0
ntptimeout=30 # seconds

/sbin/udevadm settle --timeout=5

set_ntpdate() {
  if [ ${ntpserver-} ]; then
    ntp_tries=$(( $ntp_tries + 10 ))
    if [ "$ntp_tries" -le "$ntptimeout" ]; then
      /usr/bin/timeout -t 10 /usr/sbin/ntpd -d -n -q -p "$ntpserver" >/dev/null 2>&1 || set_ntpdate
    fi
  fi
}

if [ -f "$config" ]; then
  . $config

  if [ "$hostname" ]; then
    echo -n "${GREEN}Setting hostname to ${MAGENTA}$hostname${NORMAL}"
    sed -i "/^127.0.0.1/c\127.0.0.1 $hostname localhost localhost.local" /etc/hosts
    echo "$hostname" > /etc/hostname
    hostname "$hostname"
    echo "${GREEN} Done.${NORMAL}"
  fi

  echo -n "${GREEN}Bringing up interface ${MAGENTA}$interface${GREEN}${NORMAL}"
  /sbin/ifconfig $interface up
  echo "${GREEN} Done.${NORMAL}"

  if [ "$ntpserver" ]; then
    echo -n "${GREEN}Waiting ${MAGENTA}${ntptimeout}s${GREEN} for NTP from ${MAGENTA}$ntpserver${NORMAL}"
    echo "$ntpserver" > /etc/sysconfig/ntpserver
    set_ntpdate
    echo "${GREEN} Done.${NORMAL}"
  else
    > /etc/sysconfig/ntpserver
  fi

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
