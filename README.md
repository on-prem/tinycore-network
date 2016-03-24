# TinyCore static/dhcp networking

A simple set of shell scripts for managing networking on [TinyCore Linux](http://tinycorelinux.net/)

# Installation

`tce-load -wi network`

**Note:** This extension is architecture independent, but hasn't been officially added to TinyCore yet. I've included the packaged extension in the [releases Downloads](https://github.com/aw/tinycore-network/releases).

# Configuration

The configuration file is located at `/usr/local/etc/network.conf`. It's a simple key/value file similar to this:

### dhcp (IPv4 only)

```
mode=dhcp
interface=eth0
hostname=mybox
```

### static IPv4

```
mode=static
interface=eth0
ip=192.0.2.2
subnet=255.255.255.0
router=192.0.2.1
dns="8.8.8.8 8.8.4.4"
hostname=mybox4
```

### static IPv6

```
mode=static
interface=eth0
ip="2001:db8::2"
subnet_ipv6="/32"
router="2001:db8::1"
dns="2001:4860:4860::8888 2001:4860:4860::8844"
hostname=mybox6
```

Notes about IPv6:

* IPv6 support requires the `ip` command from `iproute2` extension: `tce-load -wi iproute2`
* IPv6 subnet length is defined through `subnet_ipv6`
* DHCPv6 is not managed by these scripts, see [Dibbler](http://klub.com.pl/dhcpv6/)
* [Privacy Extensions](http://www.tldp.org/HOWTO/Linux+IPv6-HOWTO/x1092.html) are not managed by these scripts

# Manual installation

To install these scripts manually:

* Copy `network.sh, network_dhcp.sh, network_static.sh, and udhcpc.script` to `/opt/`
* Create and edit the config at `/usr/local/etc/network.conf`
* Add '/opt/network.sh' to `/opt/bootsync.sh`
* Add the scripts and config file to `/opt/.filetool.lst` for persistence

# How it works

The `network.sh` script reads values from `network.conf`, sets them as temporary environment variables and passes them to either `network_static.sh` or `network_dhcp.sh`. Those scripts will use `udhcpc` to release or renew a DHCP lease.

# Changelog

See the [Changelog](CHANGELOG.md).

# License

This project is MIT licensed, see the [LICENSE](LICENSE) file for more info.

The following files are licensed under [GPL-V2](LICENSE-GPL):

* udhcpc.script
* udhcpc.script.orig
