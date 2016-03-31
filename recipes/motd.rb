#
# Cookbook Name:: java-sample
# Recipe:: motd
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'motd::knife_status'

pam_config = "/etc/pam.d/sshd"
motd_noupdate = /(session\s+\w+\s+pam_motd\.so\s+.*)\s+noupdate\b/m

ruby_block "update motd on ssh login" do
  block do
    sed = Chef::Util::FileEdit.new(pam_config)
    sed.search_file_replace(motd_noupdate, '\1')
    sed.write_file
  end
  only_if { ::File.readlines(pam_config).grep(motd_noupdate).any? }
end

package 'landscape-common'

template '/etc/chef/env.json' do
  source 'env.json.erb'
end

template '/etc/landscape/client.conf' do
  source 'client.conf.erb'
  variables(
    plugins: node['express42']['landscape']['plugins']
  )
end

cookbook_file '/usr/lib/python2.7/dist-packages/landscape/sysinfo/express42_chef.py' do
  source 'express42_chef.py'
  action :create
end

cookbook_file '/usr/lib/python2.7/dist-packages/landscape/sysinfo/express42_chefenv.py' do
  source 'express42_chefenv.py'
  action :create
end

cookbook_file '/usr/lib/python2.7/dist-packages/landscape/sysinfo/express42_load.py' do
  source 'express42_load.py'
  action :create
end

cookbook_file '/usr/lib/python2.7/dist-packages/landscape/sysinfo/express42_memory.py' do
  source 'express42_memory.py'
  action :create
end

motd '98-knife-status' do
  action :delete
end

motd '10-help-text' do
  action :delete
end
 
