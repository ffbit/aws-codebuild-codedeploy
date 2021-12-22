#!/bin/bash

# See
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-instances.html
# https://jmespath.org/tutorial.html
aws ec2 describe-instances \
    --filter "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].[InstanceId,State.[Name] | [0],PublicIpAddress,PublicDnsName,Tags[?Key=='aws:autoscaling:groupName'].Value | [0]]" \
    --output table
