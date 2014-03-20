class profile::router::base {
  ###
  # configure vyatta router
  ###
  class { 'vyatta':
    script_dir    => '/home/vagrant',
    configuration => '/home/vyos/configuration',
    host_name     => 'vyos',
    time_zone     => 'UTC',
  }

  # vagrant management interface
  vyatta::interfaces::loopback { 'lo': address => '127.0.0.1/32' }

  vyatta::interfaces::ethernet { 'eth0': address => 'dhcp', }

  # ################# system
  vyatta::system::login { 'vyatta':
    encrypted_password => '$6$GUyv4c3u7RZwjhRx$44.RQbxRI.nMEeV.ZJx61K7xMYQpAmOR8VjdWd3Wkz7TuG44eeygBoG2u9B3Jv8Cbfr0i.JTTwnrC5MDUkclI/',
    # Password: vyatta
    level              => 'admin',
  }

  vyatta::system::login { 'vagrant':
    encrypted_password => '$6$GUyv4c3u7RZwjhRx$44.RQbxRI.nMEeV.ZJx61K7xMYQpAmOR8VjdWd3Wkz7TuG44eeygBoG2u9B3Jv8Cbfr0i.JTTwnrC5MDUkclI/',
    # Password: vyatta
    level              => 'admin',
    key_name           => 'vagrant_insecure',
    key_type           => 'ssh-rsa',
    key_content        => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==',
  }

  vyatta::service::ssh { 'ssh': port => 22 }

  vyatta::system::ntp { 'time.nrc.ca': }

  vyatta::system::ntp { 'time.chu.nrc.ca': }

  # repos
  vyatta::system::package { 'community':
    components   => 'main',
    distribution => 'hydrogen',
    url          => 'http://packages.vyos.net/vyos',
  }

  vyatta::system::package { 'vyatta4people':
    components   => 'main',
    distribution => 'experimental',
    url          => 'http://packages.vyatta4people.org/debian',
  }

  vyatta::system::package { 'puppet':
    components   => 'main dependencies',
    distribution => 'stable',
    url          => 'http://apt.puppetlabs.com',
  }

  vyatta::system::package { 'squeeze':
    components   => 'main contrib non-free',
    distribution => 'squeeze',
    url          => 'http://mirrors.kernel.org/debian',
    username     => '',
    password     => ''
  }

  vyatta::system::syslog::global { 'all': level => 'notice' }

  vyatta::system::syslog::global { 'protocols': level => 'debug' }
}