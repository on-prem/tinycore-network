#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015-2016 Alexander Williams, Unscramble <license@unscramble.jp>

pid="/var/run/udhcpc.${interface}.pid"

if [ -f "$pid" ]; then
  kill `cat $pid`
fi

/sbin/udhcpc -b -i $interface -x hostname:$(/bin/hostname) -p $pid -s /opt/udhcpc.script >>/var/log/udhcpc.log 2>&1
