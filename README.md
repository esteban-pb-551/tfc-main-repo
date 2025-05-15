# Terraform Projects Collection

This repository contains a collection of Terraform projects, each organized in its own folder, designed to manage various infrastructure components on AWS. [Terraform](https://www.terraform.io/) is an open-source infrastructure-as-code tool that allows you to define and provision infrastructure using a declarative configuration language.

## Projects

The following table lists the Terraform projects included in this repository along with a brief description of each:

| Project Folder           | Description |
|--------------------------|-------------|
| 00-base-aws              | Base Terraform Example for AWS Service Catalog AppRegistry |
| aws-microservices        | Example of AWS Microservices with Terraform |
| checkov-workshop         | Example of Checkov with Terraform |
| aws-config               | Simple example of AWS-Config with Terraform |
| eks-demo-deployments     | EKS complete example  |
| github-actions           | Example of GitHub Actions with AWS and Rust |
| goof-master              | Example of Snyk Infrastructure as code. |
| rust-example             | Rust and Lambda with Terraform |
| vulnerable-ec2           | Example of vulnerability in EC2 instance

## About Checkov

[Checkov](https://www.checkov.io/) is a static code analysis tool for infrastructure-as-code (IaC) that helps identify security and compliance issues in your Terraform, CloudFormation, Kubernetes, and ARM templates. It scans your IaC files for misconfigurations and provides actionable insights to improve the security posture of your cloud infrastructure.

## Usage

To use any of the Terraform projects in this repository, follow these general steps:

1. **Navigate to the project folder**: Change to the directory of the desired project, e.g., `cd vpc-setup`.
2. **Initialize Terraform**: Run `terraform init` to download the necessary provider plugins and set up the working directory.
3. **Customize variables**: Review and modify the `variables.tf` file (or any other variable files) to suit your needs.
4. **Plan the infrastructure**: Execute `terraform plan` to preview the changes Terraform will make.
5. **Apply the changes**: Run `terraform apply` to provision the infrastructure. Confirm the action when prompted.

For detailed instructions specific to each project, refer to the `README.md` file located within the respective project folder.

## Prerequisites

Before using the projects in this repository, ensure the following requirements are met:

- **Terraform**: Version 0.14.0 or higher installed. Download it from [terraform.io/downloads.html](https://www.terraform.io/downloads.html).
- **AWS CLI**: Configured with appropriate credentials. Install and configure it following the [AWS CLI documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).
- **AWS Account**: Access to an AWS account with the necessary permissions to create and manage the resources defined in the projects.

## Contributing

Contributions to enhance existing projects or add new ones are welcome! To contribute, please follow these steps:

1. **Fork the repository**: Create your own copy of the repository on your GitHub account.
2. **Create a branch**: Make a new branch for your changes, e.g., `git checkout -b feature/new-project`.
3. **Make changes**: Implement your updates or additions and commit them with clear, descriptive messages.
4. **Push to your fork**: Upload your changes to your forked repository.
5. **Submit a pull request**: Open a pull request to the main repository for review.
