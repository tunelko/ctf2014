#!/bin/bash

# install openvswitch 
# should try 

if [ $EUID != 0 ]
then 
  echo 'got root?'
  exit 1
fi


function create_vlan()
{
  bridge=$1
  vlan=$2
  vlan_num=$3

  #ovs-vsctl add-br $vlan $bridge $vlan_num (might be good only for kvm)
  ip tuntap add ${vlan} mode tap
  ip link set ${vlan} up
  ovs-vsctl add-port $bridge ${vlan} tag=$vlan_num 
}

function delete_vlan()
{
  vlan=$1
  bridge=$2
  ip link set ${vlan} down
  ip tuntap del ${vlan} mode tap
}

team_count=3
if [ "$1" == 'create' ]; then 
  #1 create main bridge
  ovs-vsctl add-br ovsbr0

  # create service vlans
  create_vlan ovsbr0 v_attacker 10
  
  create_vlan ovsbr0 v_target 11
  

  for ((team=1; team<=$team_count; team++))
  do
    create_vlan ovsbr0 v_dirty_t$team $((100+$team))
    create_vlan ovsbr0 v_soaked_t$team $((200+$team))
    create_vlan ovsbr0 v_clean_t$team $((300+$team))
  done
  
elif [ "$1" == 'delete' ]
then 

  delete_vlan v_attacker
  delete_vlan v_target
  
  for ((team=1; team<=$team_count; team++))
  do
    delete_vlan v_dirty_t$team
    delete_vlan v_soaked_t$team
    delete_vlan v_clean_t$team
  done

  #1 create main bridge
  ovs-vsctl del-br ovsbr0
  
elif [ "$1" == 'show' ]
then
  echo "### Showing off tun devices"
  ip tuntap
  echo "### Showing off switch config"
  ovs-vsctl show
else 
  echo 'Please specify show, create or delete.'
  exit 1;
fi
