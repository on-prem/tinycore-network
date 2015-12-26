#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015 Alexander Williams, Unscramble <license@unscramble.jp>

pid="/var/run/udhcpc.${interface}.pid"

/opt/udhcpc.script deconfig
/sbin/udhcpc -b -i $interface -h $(/bin/hostname) -p $pid -s /opt/udhcpc.script >/dev/null 2>&1 &
