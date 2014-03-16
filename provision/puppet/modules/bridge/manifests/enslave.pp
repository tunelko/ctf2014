define bridge::enslave ($bridge_device, $interface) {
  require bridge
  exec { "brctl addbr ${bridge_device} for ${name}":
    command => "brctl addbr ${bridge_device}",
    unless  => "cat /proc/net/dev | grep ${bridge_device}",
    path    => ['/bin', '/sbin', '/usr/bin'],
    require => Package['bridge-utils']
  }

  exec { "brctl addif ${bridge_device} ${interface}":
    unless  => "brctl show ${bridge_device} | grep ${interface}",
    path    => ['/bin', '/sbin', '/usr/bin'],
    require => Exec["brctl addbr ${bridge_device} for ${name}"]
  }

  exec { "ifconfig ${bridge_device} up for ${name}":
    command => "ifconfig ${bridge_device} up",
    onlyif  => "brctl show ${bridge_device} | grep ${interface}",
    unless  => "ifconfig | grep ${bridge_device}",
    path    => ['/bin', '/sbin', '/usr/bin'],
    require => Exec["brctl addbr ${bridge_device} for ${name}"]
  }

}