#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015 Alexander Williams, Unscramble <license@unscramble.jp>

pid="/var/run/udhcpc.${interface}.pid"

if [ -f "$pid" ]; then
  kill -USR2 `cat $pid`
  kill `cat $pid`
fi

/usr/share/udhcpc/default.script renew
