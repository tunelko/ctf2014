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

  vyatta::interfaces::ethernet::firewall { 'test':
    ethernet => 'eth0',
    in_ipv4  => 'firewall_name'
  }

  # ################# system
  vyatta::system::login::user { 'vyatta':
    encrypted_password => '$6$GUyv4c3u7RZwjhRx$44.RQbxRI.nMEeV.ZJx61K7xMYQpAmOR8VjdWd3Wkz7TuG44eeygBoG2u9B3Jv8Cbfr0i.JTTwnrC5MDUkclI/',
    # Password: vyatta
    level              => 'admin',
  }

  # Password: vyatta
  vyatta::system::login::user { 'vagrant':
    encrypted_password => '$6$GUyv4c3u7RZwjhRx$44.RQbxRI.nMEeV.ZJx61K7xMYQpAmOR8VjdWd3Wkz7TuG44eeygBoG2u9B3Jv8Cbfr0i.JTTwnrC5MDUkclI/',
    level              => 'admin',
  }

  vyatta::system::login::user::public_key { 'vagrant_insecure':
    account => 'vagrant',
    type    => 'ssh-rsa',
    content => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==',
  }

  vyatta::service::ssh { 'ssh': port => 22 }

  vyatta::service::https { 'https': }

  vyatta::system::ntp::server { 'time.nrc.ca': dynamic => true }

  vyatta::system::ntp::server { 'time.chu.nrc.ca': }

  # repos
  vyatta::system::package::repository { 'community':
    components   => 'main',
    distribution => 'hydrogen',
    url          => 'http://packages.vyos.net/vyos',
  }

  vyatta::system::package::repository { 'vyatta4people':
    components   => 'main',
    distribution => 'experimental',
    url          => 'http://packages.vyatta4people.org/debian',
  }

  vyatta::system::package::repository { 'puppet':
    components   => 'main dependencies',
    distribution => 'stable',
    url          => 'http://apt.puppetlabs.com',
  }

  vyatta::system::package::repository { 'squeeze':
    components   => 'main contrib non-free',
    distribution => 'squeeze',
    url          => 'http://mirrors.kernel.org/debian',
    username     => '',
    password     => ''
  }

  # SYSLOG
  vyatta::system::syslog::file { 'devel': archive_files => 20 }

  vyatta::system::syslog::file::facility { 'devel-all':
    file     => 'devel',
    facility => 'all',
    level    => 'debug',
  }

  vyatta::system::syslog::file::facility { 'devel-local7':
    file     => 'devel',
    facility => 'local7',
  }

  vyatta::system::syslog::file { 'prod': archive_files => 20 }

  vyatta::system::syslog::file::facility { 'prod-local7':
    file     => 'prod',
    facility => 'local7',
  }

  vyatta::system::syslog::host { 'syslog.example.com': }

  vyatta::system::syslog::host::facility { 'syslog.example.com-all':
    host     => 'syslog.example.com',
    facility => 'all',
    level    => 'debug'
  }

  vyatta::system::syslog::user { 'root': }

  vyatta::system::syslog::user::facility { 'all': user => 'root', }

  vyatta::system::syslog::global { 'global': archive_files => 20 }

  vyatta::system::syslog::global::facility { 'all': level => 'notice' }

  vyatta::system::syslog::global::facility { 'protocols': level => 'debug' }

  vyatta::system::syslog::console { 'console': }

  vyatta::system::syslog::console::facility { 'protocols': level => 'debug' }

}