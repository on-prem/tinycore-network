# TinyCore static/dhcp networking

A simple set of shell scripts for managing networking on [TinyCore Linux](http://tinycorelinux.net/)

# Installation

`tce-load -wi network`

**Note:** This extension is architecture independent, but hasn't been officially added to TinyCore yet. I've included the packaged extension in the [releases Downloads](https://github.com/aw/tinycore-network/releases).

# Configuration

The configuration file is located at `/usr/local/etc/network.conf`. It's a simple key/value file similar to this:

```
mode=static
interface=eth0
ip=192.168.2.2
subnet=255.255.255.0
router=192.168.2.1
dns="192.168.2.1 8.8.8.8 8.8.4.4"
```

Possible modes are: `static` or `dhcp`.

# Manual installation

To install these scripts manually:

* Copy `network.sh, network_dhcp.sh and network_static.sh` to `/opt/`
* Create and edit the config at `/usr/local/etc/network.conf`
* Add '/opt/network.sh' to `/opt/bootsync.sh`
* Add the scripts and config file to `/opt/.filetool.lst` for persistence

# How it works

The `network.sh` script reads values from `network.conf`, sets them as temporary environment variables and passes them to either `network_static.sh` or `network_dhcp.sh`. Those scripts will use `udhcpc` to release or renew a DHCP lease.

# License

This project is MIT licensed, see the [LICENSE](LICENSE) file for more info.
