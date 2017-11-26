#!/bin/bash
aws ec2 disassociate-address --association-id eipassoc-95380baa
aws ec2 release-address --allocation-id eipalloc-c8ca89f5
aws ec2 terminate-instances --instance-ids i-09a7a661a05f5cce9
aws ec2 wait instance-terminated --instance-ids i-09a7a661a05f5cce9
aws ec2 delete-security-group --group-id sg-3c23de40
aws ec2 disassociate-route-table --association-id rtbassoc-ddb876a6
aws ec2 delete-route-table --route-table-id rtb-5df9ad24
aws ec2 detach-internet-gateway --internet-gateway-id igw-956173f2 --vpc-id vpc-9d5045fb
aws ec2 delete-internet-gateway --internet-gateway-id igw-956173f2
aws ec2 delete-subnet --subnet-id subnet-8da2d1c5
aws ec2 delete-vpc --vpc-id vpc-9d5045fb
echo If you want to delete the key-pair, please do it manually.
