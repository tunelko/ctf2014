include bridge 

bridge::enslave { 'br0-eth1':
 bridge_device => 'br0',
 interface => 'eth1' 
}

bridge::enslave { 'br0-eth2':
 bridge_device => 'br0',
 interface => 'eth2' 
}