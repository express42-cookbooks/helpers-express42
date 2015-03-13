#
# Cookbook Name:: base
# Recipe:: kvm-host
#
# Author:: LLC Express 42 (info@express42.com)
#
# Copyright (C) LLC 2014 Express 42
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

node['express42']['kvm_host']['packages'].each do |pkg|
  package pkg
end

include_recipe 'sysctl'

service 'libvirt-bin' do
  action :enable
end

sysctl_param 'vm.swappiness' do
  value 0
end

sysctl_param 'vm.zone_reclaim_mode' do
  value 0
end

execute 'destroy_default_bridge' do
  command 'virsh net-destroy default && virsh net-undefine default'
  only_if 'virsh net-list | grep default'
  notifies :restart, 'service[libvirt-bin]', :delayed
end
