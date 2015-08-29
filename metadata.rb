name             'helpers_express42'
maintainer       'LLC Express 42'
maintainer_email 'cookbooks@express42.com'
license          'MIT'
description      'Installs Express42 helpers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.7'

recipe           'helpers_express42::default', 'Do nothing.'
recipe           'helpers_express42::mail', 'Configures mail exception handler.'
recipe           'helpers_express42::network', 'Includes Express 42 network module.'
recipe           'helpers_express42::packages', 'Installs Express 42 extra packages.'
recipe           'helpers_express42::kvm_host', 'Base config and packages for KVM virtualization'

supports         'debian'
supports         'ubuntu'

depends          'sysctl'
