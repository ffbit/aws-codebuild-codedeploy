# AWS CodeBuild/CodeDeploy Node.js Application for AWS CodePipeline
A sample Node.js web application with AWS CodeBuild [1] build specification [2] and 
AWS CodeDeploy [3] application specification [4] integrated into CodePipeline [5].

## AWS CodeBuild
For information related to the build see `buildspec.yaml`.

## AWS CodeDeploy
For information related to the deployment see `appspec.yml`.

### IAM Instance Profile Role for Target EC2 Instances
Create and attach a instance profile role to EC2 instances containing:
- AmazonSSMManagedInstanceCore AWS managed policy for the AWS Systems Manager agent to install the AWS CodeDeploy agent [6] on EC2 Instances.
- A policy with read-only access to the artifact's S3 bucket to download the installed artifact.

### IAM CodeDeploy Service Role
Create and set a service profile role to the CodeDeploy stage containing:
- AWSCodeDeployRole AWS managed policy to orchestrate EC2/On-Premises deployments [7].
- Add additional permissions for Auto Scaling groups with a launch template [7]: 
  - ec2:RunInstances
  - ec2:CreateTags
  - iam:PassRole

### Networking
The AWS CodeDeploy agent requires outbound internet access from EC2 instances to CodeDeploy and S3 endpoints [8],[9],[10].

## Reference
- [1] https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html
- [2] https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html
- [3] https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html
- [4] https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html
- [5] https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html
- [6] https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-iam-instance-profile.html
- [7] https://docs.aws.amazon.com/codedeploy/latest/userguide/getting-started-create-service-role.html
- [8] https://docs.aws.amazon.com/codedeploy/latest/userguide/data-protection.html
- [9] https://docs.aws.amazon.com/codedeploy/latest/userguide/vpc-endpoints.html
- [10] https://docs.aws.amazon.com/codedeploy/latest/userguide/troubleshooting-deployments.html

