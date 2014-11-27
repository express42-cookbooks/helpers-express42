# Description

Installs Express42 helpers

# Requirements

## Platform:

* Debian
* Ubuntu

## Cookbooks:

*No dependencies defined*

# Attributes

* `node['express42']['packages']` -  Defaults to `"%w(nscd screen vim curl sysstat gdb dstat tcpdump strace iozone3 htop tmux byobu mailutils ncdu mosh iotop atop zsh mutt)"`.
* `node['express42']['extra-packages']` -  Defaults to `"[ ... ]"`.
* `node['express42']['private_networks']` -  Defaults to `"192.168.0.0/16,172.16.0.0/12,10.0.0.0/8"`.
* `node['express42']['handler']['mail_from']` -  Defaults to `"chef@express42.com"`.
* `node['express42']['handler']['mail_to']` -  Defaults to `"[ ... ]"`.

# Recipes

* helpers-express42::default
* helpers-express42::mail
* helpers-express42::network
* helpers-express42::packages

# License and Maintainer

Maintainer:: LLC Express 42 (<info@express42.com>)

License:: MIT
