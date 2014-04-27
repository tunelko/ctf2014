#!/bin/bash
set -e 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STATE="$DIR/state"
if [ -f $STATE ];
then
  echo -n "State file already exists, do you want to make a backup (Y/n)? " 
  IFS= read -r answer
  if [ "$answer" == "Y" -o "$answer" == "y" ];
  then 
    mv $STATE $STATE.backup
  fi
fi
export EC2_HOME="${DIR}/ec2-api-tools-1.6.13.0"
BIN=$EC2_HOME/bin
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
# load private key from rootkey.csv
export AWS_ACCESS_KEY=$(awk -F '=' '/AWSAccessKey/ {print $2}' ${DIR}/rootkey.csv)
export AWS_SECRET_KEY=$(awk -F '=' '/AWSSecretKey/ {print $2}' ${DIR}/rootkey.csv)


# create VPC
VPC_ID=$($BIN/ec2-create-vpc 10.10.0.0/16 | awk '{print $2}')
$BIN/ec2-create-tags $VPC_ID -t 'Name=ctf101-test'

# create dhcp-options and associate then with VPC
DHCP_ID=$($BIN/ec2-create-dhcp-options 'domain-name=ctf101' 'domain-name-servers=8.8.8.8' | awk '/DHCPOPTIONS/ {print $2}')
$BIN/ec2-create-tags $DHCP_ID -t 'Name=ctf101-dhcpoptions'
$BIN/ec2-associate-dhcp-options -c $VPC_ID $DHCP_ID

# create an internet gateway
INETGW_ID=$($BIN/ec2-create-internet-gateway | awk '{print $2}')
$BIN/ec2-create-tags $INETGW_ID -t 'Name=ctf101-inetgw'
$BIN/ec2-attach-internet-gateway -c $VPC_ID $INETGW_ID

# get automatically created routing table and attach it to the internet gateway
RT_ID=$($BIN/ec2-describe-route-tables | awk "/ROUTETABLE/ && /$VPC_ID/ {print \$2}")
$BIN/ec2-create-tags $RT_ID -t 'Name=ctf101-rt'

# add default route to the internet in routing table
$BIN/ec2-create-route $RT_ID -r 0.0.0.0/0 -g $INETGW_ID

# create subnets and associate to routing table
WEBTIER_ID=$($BIN/ec2-create-subnet -c $VPC_ID -i 10.10.1.0/24 | awk '{print $2}')
$BIN/ec2-create-tags $WEBTIER_ID -t 'Name=web-tier-test'
$BIN/ec2-associate-route-table -s $WEBTIER_ID $RT_ID
APPTIER_ID=$($BIN/ec2-create-subnet -c $VPC_ID -i 10.10.2.0/24 | awk '{print $2}')
$BIN/ec2-create-tags $APPTIER_ID -t 'Name=app-tier-test'
$BIN/ec2-associate-route-table -s $APPTIER_ID $RT_ID
DATATIER_ID=$($BIN/ec2-create-subnet -c $VPC_ID -i 10.10.10.0/24 | awk '{print $2}')
$BIN/ec2-create-tags $DATATIER_ID -t 'Name=data-tier-test'
$BIN/ec2-associate-route-table -s $DATATIER_ID $RT_ID
MGMTTIER_ID=$($BIN/ec2-create-subnet -c $VPC_ID -i 10.10.100.0/24 | awk '{print $2}')
$BIN/ec2-create-tags $MGMTTIER_ID -t 'Name=mgmt-tier-test'
$BIN/ec2-associate-route-table -s $MGMTTIER_ID $RT_ID

# Modify network ACLs

# Create VPC security group
SECGROUP_ID=$($BIN/ec2-create-group -c $VPC_ID -d 'ctf101 Security group' ctf101-secgroup | awk '{print $2}')
# create allow all rules
$BIN/ec2-authorize $SECGROUP_ID -P icmp -t -1:-1
$BIN/ec2-authorize $SECGROUP_ID -P tcp -p -1
$BIN/ec2-authorize $SECGROUP_ID -P udp -p -1
$BIN/ec2-authorize --egress $SECGROUP_ID -P icmp -t -1:-1
$BIN/ec2-authorize --egress $SECGROUP_ID -P tcp -p -1
$BIN/ec2-authorize --egress $SECGROUP_ID -P udp -p -1

# export variables to file
echo "VPC_ID=${VPC_ID}" > $STATE
echo "DHCP_ID=${DHCP_ID}" >> $STATE
echo "INETGW_ID=${INETGW_ID}" >> $STATE
echo "RT_ID=${RT_ID}" >> $STATE
echo "WEBTIER_ID=${WEBTIER_ID}" >> $STATE
echo "APPTIER_ID=${APPTIER_ID}" >> $STATE
echo "DATATIER_ID=${DATATIER_ID}" >> $STATE
echo "MGMTTIER_ID=${MGMTTIER_ID}" >> $STATE
echo "SECGROUP_ID=${SECGROUP_ID}" >> $STATE
