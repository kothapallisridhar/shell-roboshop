#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0bc63e9f6186d8b9c"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
ZONE_ID="Z00739521QV9O17MO88NQ"
DOMAIN_NAME="adevops.shop"

for instance in ${INSTANCES[@]}
do 
    INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t2.micro --security-group-ids sg-0bc63e9f6186d8b9c --tag-specifications "ResourceType=instance,Tags[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text) 
    if [ $instance != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
    else 
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    fi  
    echo "$instance IP address: $IP"  
done

