name             'helpers_express42'
maintainer       'LLC Express 42'
maintainer_email 'cookbooks@express42.com'
license          'MIT'
description      'Installs Express42 helpers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.8'
source_url       'https://github.com/express42-cookbooks/helpers_express42' if respond_to?(:source_url)
issues_url       'https://github.com/express42-cookbooks/helpers_express42/issues' if respond_to?(:issues_url)

recipe           'helpers_express42::default', 'Do nothing.'
recipe           'helpers_express42::motd', 'Configures Message of the Day'
recipe           'helpers_express42::mail', 'Configures mail exception handler.'
recipe           'helpers_express42::network', 'Includes Express 42 network module.'
recipe           'helpers_express42::packages', 'Installs Express 42 extra packages.'
recipe           'helpers_express42::kvm_host', 'Base config and packages for KVM virtualization'

supports         'debian'
supports         'ubuntu'

depends          'sysctl'
