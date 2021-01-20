#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015-2021 Alexander Williams, Unscramble <license@unscramble.jp>
#
# VERSION: 1.11.1

. /etc/init.d/tc-functions
set -a

config="/usr/local/etc/network.conf"
ntp_tries=0
ntptimeout=60 # seconds
ntpretry=20   # seconds
interface_tries=0
dasht="-t"

/sbin/udevadm settle --timeout=5

check_status() {
  if [ "$?" = 1 ]; then
    echo "${RED} Failed.${NORMAL}"
  else
    echo "${GREEN} Done.${NORMAL}"
  fi
}

set_ntpdate() {
  if [ ${ntpserver-} ]; then
    ntp_tries=$(( $ntp_tries + $ntpretry ))
    if [ "$ntp_tries" -le "$ntptimeout" ]; then
      echo -n "."
      /usr/bin/timeout 2>&1 | grep -q '\-t SECS'
      if [ "$?" = 1 ]; then
        dasht=""
      fi
      /usr/bin/timeout $dasht $ntpretry /usr/sbin/ntpd -d -n -q -p "$ntpserver" >>/var/log/ntp.log 2>&1 || set_ntpdate
    else
      return 1
    fi
  fi
}

check_interface() {
  interface_tries=$(( $interface_tries + 1 ))
  if [ "$interface_tries" -le 10 ]; then # wait up to 10 seconds
    echo -n "."
    sleep 1
    /sbin/ifconfig $interface 2>&1 | grep HWaddr >/dev/null 2>&1 || check_interface
  else
    return 1
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
  # ensure the interface is actually up
  check_interface
  check_status

  case "$mode" in
    static)
      /opt/network_static.sh
      ;;
    dhcp)
      /opt/network_dhcp.sh
      ;;
  esac

  # configure NTP after the interface is configured
  if [ "$ntpserver" ]; then
    echo -n "${GREEN}Waiting up to ${MAGENTA}${ntptimeout}s${GREEN} for NTP from ${MAGENTA}$ntpserver${NORMAL}"
    echo "$ntpserver" > /etc/sysconfig/ntpserver
    set_ntpdate
    check_status
  else
    > /etc/sysconfig/ntpserver
  fi
else
  echo "${RED}Missing network config: ${RED}${config}${NORMAL}"
  exit 1
fi

exit 0
