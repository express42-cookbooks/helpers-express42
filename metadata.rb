name             'helpers-express42'
maintainer       'LLC Express 42'
maintainer_email 'cookbooks@express42.com'
license          'MIT'
description      'Installs Express42 helpers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.3'

recipe           'helpers-express42::default', 'Do nothing.'
recipe           'helpers-express42::mail', 'Configures mail exception handler.'
recipe           'helpers-express42::network', 'Includes Express 42 network module.'
recipe           'helpers-express42::packages', 'Installs Express 42 extra packages.'

supports         'debian'
supports         'ubuntu'

depends          'sysctl'
