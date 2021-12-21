#!/bin/bash

# See
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-instances.html
# https://jmespath.org/tutorial.html
aws ec2 describe-instances \
    --filter "Name=instance-state-name,Values=running" "Name=tag:Application,Values=aws-codebuild-codedeploy"  \
    --query "Reservations[*].Instances[*].[InstanceId,PublicIpAddress,PublicDnsName]" \
    --output table

