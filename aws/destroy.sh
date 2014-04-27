#!/bin/bash
set -e
# Setup AWS
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STATE="$DIR/state"
if [ ! -f $STATE ];
then
  echo -n "cannot read state file: $STATE"
  exit 1
fi
source $STATE
export EC2_HOME="${DIR}/ec2-api-tools-1.6.13.0"
BIN=$EC2_HOME/bin
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
# load private key from rootkey.csv
export AWS_ACCESS_KEY=$(awk -F '=' '/AWSAccessKey/ {print $2}' ${DIR}/rootkey.csv)
export AWS_SECRET_KEY=$(awk -F '=' '/AWSSecretKey/ {print $2}' ${DIR}/rootkey.csv)

## DELETE
$BIN/ec2-delete-subnet $WEBTIER_ID
$BIN/ec2-delete-subnet $APPTIER_ID
$BIN/ec2-delete-subnet $DATATIER_ID
$BIN/ec2-delete-subnet $MGMTTIER_ID
$BIN/ec2-detach-internet-gateway -c $VPC_ID $INETGW_ID
$BIN/ec2-delete-internet-gateway $INETGW_ID
$BIN/ec2-delete-route -r 0.0.0.0/0 $RT_ID
$BIN/ec2-delete-group $SECGROUP_ID
$BIN/ec2-delete-vpc $VPC_ID
$BIN/ec2-delete-dhcp-options $DHCP_ID

rm $STATE
