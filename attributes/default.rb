default['express42']['packages'] = %w(screen vim curl sysstat gdb dstat tcpdump strace htop tmux mailutils ncdu iotop atop)
default['express42']['extra-packages'] = []

default['express42']['private_networks'] = '192.168.0.0/16,172.16.0.0/12,10.0.0.0/8'

default['express42']['handler']['mail_from'] = 'chef@express42.com'
default['express42']['handler']['mail_to'] = ['']
