#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015-2016 Alexander Williams, Unscramble <license@unscramble.jp>

pid="/var/run/udhcpc.${interface}.pid"

if [ -f "$pid" ]; then
  kill -USR2 `cat $pid`
  kill `cat $pid`
fi

/opt/udhcpc.script deconfig
/opt/udhcpc.script renew
