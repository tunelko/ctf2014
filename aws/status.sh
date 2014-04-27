#!/bin/bash
set -e 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/api.sh

STATE="$DIR/state"
if [ ! -f $STATE ];
then
  exit
fi

source $STATE

eval $($BIN/ec2-describe-vpcs $VPC_ID | awk '
  {
   if($1=="TAG")
     print "vpc_name="$5
   if($1 =="VPC")
     print "stat="$3,"range="$4;
  }')

echo "--------"
echo "VPC"
echo "--------"
echo "Name:   "$vpc_name
echo "Status: "$stat
echo "Range:  "$range

echo "--------"
echo "DHCP"
echo "--------"

$BIN/ec2-describe-dhcp-options -F 'tag-value=ctf101-dhcpoptions' | awk '
  {
   if($1=="TAG")
     print "Name: "$5
   if($1 =="OPTION")
     print $2": "$3;
  }'

echo "--------"
echo "Gateway"
echo "--------"
$BIN/ec2-describe-internet-gateways -F 'tag-value=ctf101-inetgw' | awk '
{
 if($1=="TAG")
   print "Name: "$5
 if($1 =="ATTACHMENT")
   print "Status: "$3;
}'

echo "--------"
echo "Security"
echo " Groups "
echo "--------"
$BIN/ec2-describe-group -F 'group-name=ctf101-public' | awk '
{
 if($1 =="PERMISSION")
   print "RULE: "$0;
}'

echo "--------"
echo "Subnets"
echo "--------"
for snet in 'data-tier' 'mgmt-tier' 'app-tier' 'web-tier'
do
  eval $($BIN/ec2-describe-subnets -F "tag-value=$snet" | awk '
  {
   if($1=="TAG")
     print "snet_name="$5
   if($1 =="SUBNET")
     print "snet_stat="$3,"snet_vpc="$4,"snet_range="$5;
  }')
  echo "Name:   "$snet_name
  echo "Range:  "$snet_range
  echo "Status: "$snet_stat
  echo "VPC:    "$snet_vpc
  echo "--------"
done

echo "--------"
echo "Systems"
echo "--------"
for ip in $T1_IP $T2_IP $T3_IP $T4_IP $T5_IP
do
  eval $($BIN/ec2-describe-instances -F "private-ip-address=$ip" | awk '
  {
   if($1 =="INSTANCE")
     print "id="$2,"ami="$3;
   if($1=="TAG")
     print "name="$5
   if($1 =="NICASSOCIATION")
     print "ext_ip="$2,"int_ip="$4;
  }')

  stat=$($BIN/ec2-describe-instance-status $id | awk "/INSTANCE/ {print \$4}")
#  echo "ID:     "$id
#  echo "AMI:    "$ami
  echo "Name:   "$name
  echo "Status: "$stat
  echo "Ext-IP: "$ext_ip
  echo "Int-IP: "$int_ip
  echo "--------"
done
