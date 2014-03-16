node 'rAttack1' {
  ###
  # configure vyatta router
  ###
  class { 'vyatta':
    configuration => '/home/vyos/configuration',
    host_name     => 'vyos',
    time_zone     => 'UTC',
  }

  vyatta::interfaces::loopback { 'lo': address => '127.0.0.1/32' }

  vyatta::interfaces::ethernet { 'eth0':
    address => 'dhcp',
    hw_id   => $macaddress_eth0
  }

  # v_attacker
  vyatta::interfaces::ethernet { 'eth1':
    address => ['10.0.0.1/24'],
    hw_id   => $macaddress_eth1
  }

  # setup team 1 to 3
  # v_dirty_t1
  vyatta::interfaces::ethernet { 'eth2':
    address => ['10.1.1.1/24'],
    hw_id   => $macaddress_eth2
  }

  #  # v_dirty_t2
  #  vyatta::interfaces::ethernet { 'eth3':
  #    address => ['10.2.1.1/24'],
  #    hw_id => $macaddress_eth3
  #  }

  #  # v_dirty_t3
  #  vyatta::interfaces::ethernet { 'eth4':
  #    address => ['10.3.1.1/24'],
  #    hw_id => $macaddress_eth4
  #  }
  #
  #  # v_dirty_t4
  #  vyatta::interfaces::ethernet { 'eth4':
  #    address => ['10.4.1.1/24'],
  #    hw_id => $macaddress_eth5
  #  }

  #  # v_dirty_t5
  #  vyatta::interfaces::ethernet { 'eth4':
  #    address => ['10.5.1.1/24'],
  #    hw_id => $macaddress_eth6
  #  }

  #  # v_dirty_t6
  #  vyatta::interfaces::ethernet { 'eth4':
  #    address => ['10.6.1.1/24'],
  #    hw_id => $macaddress_eth7
  #  }

  # ################# system
  vyatta::system::login { 'vyatta':
    encrypted_password => '$6$GUyv4c3u7RZwjhRx$44.RQbxRI.nMEeV.ZJx61K7xMYQpAmOR8VjdWd3Wkz7TuG44eeygBoG2u9B3Jv8Cbfr0i.JTTwnrC5MDUkclI/',
    # Password: vyatta
    level     => 'admin',
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

  vyatta::system::ntp { '0.vyatta.pool.ntp.org': }

  vyatta::system::ntp { '1.vyatta.pool.ntp.org': }

  vyatta::system::ntp { '2.vyatta.pool.ntp.org': }

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

}