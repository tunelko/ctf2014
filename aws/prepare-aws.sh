#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export EC2_HOME="${DIR}/ec2-api-tools-1.6.13.0"
BIN=$EC2_HOME/bin
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
# load private key from rootkey.csv
export AWS_ACCESS_KEY=$(awk -F '=' '/AWSAccessKey/ {print $2}' ${DIR}/rootkey.csv)
export AWS_SECRET_KEY=$(awk -F '=' '/AWSSecretKey/ {print $2}' ${DIR}/rootkey.csv)

# create dhcp-options 
DHCP_ID=$($BIN/ec2-create-dhcp-options 'domain-name=ctf101' 'domain-name-servers=8.8.8.8' | awk '/DHCPOPTIONS/ {print $2}')
$BIN/ec2-create-tags $DHCP_ID -t 'Name=ctf101-dhcpoptions'
$BIN/ec2-associate-dhcp-options -c $VPC_ID $DHCP_ID

VPC_ID=$($BIN/ec2-create-vpc 10.10.0.0/16 | awk '{print $2}')
$BIN/ec2-create-tags $VPC_ID -t 'Name=CTF101-test'


# create a internet gateway
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

## DELETE
$BIN/ec2-delete-subnet $WEBTIER_ID
$BIN/ec2-delete-subnet $APPTIER_ID
$BIN/ec2-delete-subnet $DATATIER_ID
$BIN/ec2-delete-subnet $MGMTTIER_ID

$BIN/ec2-detach-internet-gateway -c $VPC_ID $INETGW_ID
$BIN/ec2-delete-internet-gateway $INETGW_ID
$BIN/ec2-delete-route -r 0.0.0.0/0 $RT_ID
$BIN/ec2-delete-vpc $VPC_ID

$BIN/ec2-delete-dhcp-options $DHCP_ID
