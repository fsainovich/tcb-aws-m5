BootCamp AWS – Module 5 project

In this project you will act as a DevSecOps Engineer. 

You received the requirement to implement a set of EC2 Instances in an automated way.

Also as part of the DevSecOps team you must install a specific security agent used by the company that will run in an automated way in all this Instances.

Instructions:

- Set parameters.tf and tfvar.tf values
- Terraform validate -> plan -> apply

Creates:
- Get ubuntu AMI;
- Create VPC and Subnet;
- Internet Gateway and Routing Table;
- Security Group;
- Role for SSM access SNS;
- SNS topic and subscription;
- EC2 Instances;

PDF file with prints of SSM outputs (is not a howto)

Configure CloudWatch Alarms with CloudTrail events:
https://docs.aws.amazon.com/pt_br/awscloudtrail/latest/userguide/cloudwatch-alarms-for-cloudtrail.html
