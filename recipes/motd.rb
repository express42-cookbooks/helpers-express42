#
# Cookbook Name:: helpers_express42
# Recipe:: motd
#
# Copyright 2016, LLC Express 42
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

package 'landscape-common'

# In Ubuntu 14.04 we need to enable update on log on
# In Ubuntu 12.04 we need to disable printing motd with sshd or we'll get motd twice

case node['platform']
when 'ubuntu'
  if node['platform_version'].to_f >= 14.04
    cookbook_file '/etc/pam.d/sshd' do
      source 'motd/sshd'
      owner 'root'
      group 'root'
      mode '0644'
      backup 1
      action :create
    end
  else
    node.default['openssh']['server']['print_motd'] = 'no'
  end
end

# Code block copied from https://github.com/chr4-cookbooks/motd
# Copyright 2012, Chris Aumann <me@chr4.org>

# Chef::Config[:interval] somehow is nil, therefore falling back to
# configuration of chef_client cookbook (if available)
# and finally the chef default of 1800s
interval = Chef::Config[:interval]
interval ||= node['chef_client']['interval'] if node.attribute?('chef_client')
interval ||= 1800

# We need to current interval in minutes
interval = Integer(interval) / 60

# As the same with interval, get the current configured interval splay.
splay = Chef::Config[:splay]
splay ||= node['chef_client']['splay'] if node.attribute?('chef_client')
splay ||= 300
# We need to current splay in minutes
splay = Integer(splay) / 60

# End of code block

template '/etc/chef/env.json' do # ~FC033
  source 'motd/env.json.erb'
  variables(
    prod_env: node['express42']['landscape']['production'],
    max_delay: interval + splay
  )
end

template '/etc/landscape/client.conf' do # ~FC033
  source 'motd/client.conf.erb'
  variables(
    plugins: node['express42']['landscape']['plugins']
  )
end

files = ['express42_chef.py', 'express42_chefenv.py', 'express42_load.py', 'express42_memory.py']

files.each do |file|
  cookbook_file '/usr/lib/python2.7/dist-packages/landscape/sysinfo/' + file do
    source 'motd/' + file
    action :create
  end
end

motd_plugins = ['10-help-text', '90-updates-available', '91-release-upgrade', '95-hwe-eol', '98-fsck-at-reboot', '98-reboot-required', '98-knife-status', '99-footer']

motd_plugins.each do |plugin|
  file '/etc/update-motd.d/' + plugin do
    action :delete
    backup 1
  end
end

# Code block copied from https://github.com/chr4-cookbooks/motd and slightly edited
# Copyright 2012, Chris Aumann <me@chr4.org>

# add a chef-handler that creates a file with the current timestamp on a successful chef-run
directory ::File.join(Chef::Config[:file_cache_path], 'handlers') do
  mode 00755
end

template ::File.join(Chef::Config[:file_cache_path], 'handlers', 'knife_status.rb') do
  mode   00644
  source 'motd/knife_status_handler.rb'
end

chef_handler 'Motd::KnifeStatus' do
  source ::File.join(Chef::Config[:file_cache_path], 'handlers', 'knife_status.rb')
  action :enable
end

# End of code block
