#!/bin/bash
aws ec2 disassociate-address --association-id eipassoc-3117490e
aws ec2 release-address --allocation-id eipalloc-c391e8fe
aws ec2 terminate-instances --instance-ids i-0962b3128935da2ab
aws ec2 wait instance-terminated --instance-ids i-0962b3128935da2ab
aws ec2 delete-security-group --group-id sg-fd3f2680
aws ec2 disassociate-route-table --association-id rtbassoc-97ab57ec
aws ec2 delete-route-table --route-table-id rtb-322b6a4b
aws ec2 detach-internet-gateway --internet-gateway-id igw-c47d77a3 --vpc-id vpc-03262665
aws ec2 delete-internet-gateway --internet-gateway-id igw-c47d77a3
aws ec2 delete-subnet --subnet-id subnet-25bbb47e
aws ec2 delete-vpc --vpc-id vpc-03262665
echo If you want to delete the key-pair, please do it manually.
