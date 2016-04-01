[![Build Status](https://travis-ci.org/express42-cookbooks/helpers_express42.svg?branch=master)](https://travis-ci.org/express42-cookbooks/helpers_express42)

# Description

Installs Express42 helpers

# Requirements

## Platform:

* Debian
* Ubuntu

## Gems:

* pony

## Dependencies:

* sysctl

# Attributes

* `node['express42']['packages']` -  Defaults to `"%w(screen vim curl sysstat gdb dstat tcpdump strace htop tmux mailutils ncdu iotop atop)"`.
* `node['express42']['extra-packages']` -  Defaults to `"[ ... ]"`.
* `node['express42']['private_networks']` -  Defaults to `"192.168.0.0/16,172.16.0.0/12,10.0.0.0/8"`.
* `node['express42']['handler']['mail_from']` -  Defaults to `"chef@express42.com"`.
* `node['express42']['handler']['mail_to']` -  Defaults to `"[ ... ]"`.
* `node['express42']['kvm_host']['packages']` -  Defaults to `"%w(qemu-kvm libvirt-bin bridge-utils virtinst)"`.
* `node['express42']['landscape']['plugins']` - Defaults to `"Express42_ChefEnv,Express42_Chef,Express42_Memory,Express42_Load,Disk"`.

# Recipes

* helpers_express42::default - Do nothing.
* helpers_express42::mail - Configures mail exception handler.
* helpers_express42::network - Includes Express 42 network module.
* helpers_express42::packages - Installs Express 42 extra packages.
* helpers_express42::kvm_host - Base config and packages for KVM virtualization
* helpers_express42::motd - Configures Message of the Day

# License and Maintainer

Maintainer:: LLC Express 42 (<cookbooks@express42.com>)

License:: MIT
