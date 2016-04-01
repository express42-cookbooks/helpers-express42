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

include_recipe 'motd::knife_status'

# Finds in /etc/pam.d/sshd line
#   session    optional     pam_motd.so  motd=/run/motd.dynamic noupdate
# and changes it to 
#   session    optional     pam_motd.so  motd=/run/motd.dynamic
# Else on ssh login you'll be seeing info from previous login rather than
# relevant status

pam_config = '/etc/pam.d/sshd'
motd_noupdate = /(session\s+\w+\s+pam_motd\.so\s+.*)\s+noupdate\b/m

ruby_block 'update motd on ssh login' do
  block do
    sed = Chef::Util::FileEdit.new(pam_config)
    sed.search_file_replace(motd_noupdate, '\1')
    sed.write_file
  end
  only_if { ::File.readlines(pam_config).grep(motd_noupdate).any? }
end

package 'landscape-common'

template '/etc/chef/env.json' do
  source 'motd/env.json.erb'
  variables(
    prod_env: node['express42']['landscape']['production']
  )
end

template '/etc/landscape/client.conf' do
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

motd '98-knife-status' do
  action :delete
end

motd '10-help-text' do
  action :delete
end
