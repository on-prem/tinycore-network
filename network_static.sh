#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015-2017 Alexander Williams, Unscramble <license@unscramble.jp>

pid="/var/run/udhcpc.${interface}.pid"

if [ -f "$pid" ]; then
  kill -USR2 `cat $pid`
  kill `cat $pid`
  rm -f "$pid"
fi

/opt/udhcpc.script deconfig >>/var/log/udhcpc.log 2>&1
/opt/udhcpc.script renew >>/var/log/udhcpc.log 2>&1
