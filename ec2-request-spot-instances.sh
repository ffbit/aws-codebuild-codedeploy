#!/bin/bash

INSTANCE_TYPE=t4g.micro
APPLICATION_TAG_KEY='Application'
APPLICATION_TAG_VALUE='aws-codebuild-codedeploy'
EC2_INSTANCE_NAME='CodeDeploy'

# Change me!
# AmazonSSMManagedInstanceCore + Read-Only access to the artifact's bucket.
IAM_INSTANCE_PROFILE_ARN='arn:aws:iam::xxxxxxxxxxxx:instance-profile/EC2SSMCore'

# Change me!
# Security group allowing HTTP + SSH traffic.
EC2_SECURITY_GROUP_ID='sg-xxxxxxxxxxxxxxxxx'

# Change me!
# Key Pair for SSH access.
EC2_KEY_PAIR='xxxxxx'

IMAGE_ID=$( \
aws ec2 describe-images \
  --filters "Name=architecture,Values=arm64" "Name=image-type,Values=machine" "Name=name,Values=amzn2-ami-kernel-5.10-hvm-2.0.20211201.0-arm64-gp2" \
  --owners amazon \
  --query 'Images[0].[ImageId]' \
  --output text)

LAUNCH_SPECIFICATION=$( \
cat << EOF
{
  "KeyName": "${EC2_KEY_PAIR}",
  "SecurityGroupIds": [
    "${EC2_SECURITY_GROUP_ID}"
  ],
  "InstanceType": "${INSTANCE_TYPE}",
  "ImageId": "${IMAGE_ID}",
  "IamInstanceProfile": {
    "Arn": "${IAM_INSTANCE_PROFILE_ARN}"
  }
}
EOF)

SPOT_REQUEST_IDS=($( \
aws ec2 request-spot-instances --instance-count 2 \
    --type 'one-time' \
    --launch-specification "${LAUNCH_SPECIFICATION}" \
    --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key='${APPLICATION_TAG_KEY}',Value='${APPLICATION_TAG_VALUE}'},{Key='Name',Value='${EC2_INSTANCE_NAME}'}]" \
    --query "SpotInstanceRequests[*].[SpotInstanceRequestId]" \
    --output text))

echo "${SPOT_REQUESTS_IDS[@]}"

date
aws ec2 wait spot-instance-request-fulfilled --spot-instance-request-ids ${SPOT_REQUEST_IDS[@]}
date


SPOT_INSTANCE_IDS=($( \
aws ec2 describe-spot-instance-requests \
    --spot-instance-request-ids ${SPOT_REQUEST_IDS[@]} \
    --query "SpotInstanceRequests[*].{ID:InstanceId}" \
    --output text))

echo "${SPOT_INSTANCE_IDS[@]}"

aws ec2 create-tags \
    --resources ${SPOT_INSTANCE_IDS[@]} \
    --tags Key="'${APPLICATION_TAG_KEY}'",Value="'${APPLICATION_TAG_VALUE}'" Key="Name",Value="'${EC2_INSTANCE_NAME}'"


aws ec2 describe-instances \
    --instance-ids "${SPOT_INSTANCE_IDS[@]}" \
    --query "Reservations[*].Instances[*].[InstanceId,PublicIpAddress,PublicDnsName]" \
    --output table

