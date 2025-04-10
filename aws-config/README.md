## AWS Config and Terraform

AWS Config provides configuration, compliance, and auditing features that are required for governing your resources and providing security posture assessment at scale.

Terraform is an IaC solution that operates in a way similar to AWS CloudFormation, the AWS native IaC solution. If you plan to use Terraform to manage your AWS environment, this post shows how to deploy controls.

### AWS Config rules
AWS Config rules are a set of rules that AWS Config uses to evaluate the configuration of your AWS resources. AWS Config provides a set of managed rules that you can use to evaluate the configuration of your resources. You can also create custom rules using AWS Lambda functions.

### AWS Config remediation
AWS Config remediation is the process of automatically correcting non-compliant resources. AWS Config provides a set of managed remediation actions that you can use to automatically correct non-compliant resources. You can also create custom remediation actions using AWS Lambda functions.

