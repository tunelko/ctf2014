####################################################
# CTF 2014
#
node 'rAttack' {
  ###
  # configure router
  ###
  include profile::router::base

  # v_attacker
  vyatta::interfaces::ethernet { 'eth1': address => ['10.0.0.1/24'], }

  # setup team 1 to N
  # v_dirty_t1
  vyatta::interfaces::ethernet { 'eth2': address => ['10.1.1.1/24'], }

#  # v_dirty_t2
#  vyatta::interfaces::ethernet { 'eth3': address => ['10.2.1.1/24'], }
#
#  # v_dirty_t3
#  vyatta::interfaces::ethernet { 'eth4': address => ['10.3.1.1/24'], }
#
#  # v_dirty_t4
#  vyatta::interfaces::ethernet { 'eth5': address => ['10.4.1.1/24'], }
#
#  # v_dirty_t5
#  vyatta::interfaces::ethernet { 'eth6': address => ['10.5.1.1/24'], }
#
#  # v_dirty_t6
#  vyatta::interfaces::ethernet { 'eth7': address => ['10.6.1.1/24'], }
#
#  # v_dirty_t7
#  vyatta::interfaces::ethernet { 'eth8': address => ['10.7.1.1/24'], }
#
#  # v_dirty_t8
#  vyatta::interfaces::ethernet { 'eth9': address => ['10.8.1.1/24'], }

}

node 'rTarget' {
  ###
  # configure router
  ###
  include profile::router::base

  # v_target
  vyatta::interfaces::ethernet { 'eth1': address => ['10.0.1.1/24'], }

  # setup team 1 to N

  # v_clean_t1
  vyatta::interfaces::ethernet { 'eth2': address => [
      '10.1.1.11/24',
      '10.1.1.12/24'], }

#  # v_clean_t2
#  vyatta::interfaces::ethernet { 'eth3': address => ['10.2.1.11/24'], }
#
#  # v_clean_t3
#  vyatta::interfaces::ethernet { 'eth4': address => ['10.3.1.11/24'], }
#
#  # v_clean_t4
#  vyatta::interfaces::ethernet { 'eth5': address => ['10.4.1.11/24'], }
#
#  # v_clean_t5
#  vyatta::interfaces::ethernet { 'eth6': address => ['10.5.1.11/24'], }
#
#  # v_clean_t6
#  vyatta::interfaces::ethernet { 'eth7': address => ['10.6.1.11/24'], }
#
#  # v_clean_t7
#  vyatta::interfaces::ethernet { 'eth8': address => ['10.7.1.11/24'], }
#
#  # v_clean_t8
#  vyatta::interfaces::ethernet { 'eth9': address => ['10.8.1.11/24'], }

}

node /^(team|vendor)\d+$/ {
  include bridge

  bridge::enslave { 'br0-eth1':
    bridge_device => 'br0',
    interface     => 'eth1'
  }

  bridge::enslave { 'br0-eth2':
    bridge_device => 'br0',
    interface     => 'eth2'
  }
}

node default {

}