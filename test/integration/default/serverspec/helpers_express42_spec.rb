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
