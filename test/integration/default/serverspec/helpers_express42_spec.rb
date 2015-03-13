require 'spec_helper'

describe package('pony') do
  let(:path) { '/opt/chef/embedded/bin:$PATH' }
  it { should be_installed.by('gem') }
end

%w(nscd screen vim curl sysstat gdb dstat tcpdump strace iozone3 htop tmux byobu mailutils ncdu mosh iotop atop zsh mutt).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

#kvm_host
%w(qemu-kvm libvirt-bin bridge-utils virtinst).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe bridge('virbr0') do
  it { should_not exist }
end

describe interface('virbr0') do
  it { should_not exist }
end

describe command('sysctl vm.swappiness') do
  its(:stdout) { should match /vm.swappiness = 0/ }
end

describe command('sysctl vm.zone_reclaim_mode') do
  its(:stdout) { should match /vm.zone_reclaim_mode = 0/ }
end
