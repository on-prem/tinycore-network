#!/bin/sh
#
# TinyCore static/dhcp networking
#
# MIT License
# Copyright (c) 2015 Alexander Williams, Unscramble <license@unscramble.jp>

/usr/share/udhcpc/default.script deconfig
/etc/init.d/dhcp.sh
