provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      env             = var.environment
      owner           = "Ops"
      applicationName = var.application_name
      awsApplication  = aws_servicecatalogappregistry_application.terraform_app.application_tag.awsApplication
      version         = var.version_app
      service         = var.application_name
      terraform       = "true"
    }
  }

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

# Create application using aliased 'application' provider
provider "aws" {
  alias  = "application"
  region = var.aws_region
}

# Register new application
# An AWS Service Catalog AppRegistry Application is displayed in the AWS Console under "MyApplications".
resource "aws_servicecatalogappregistry_application" "terraform_app" {
  provider    = aws.application
  name        = var.application_name
  description = "Terraform EC2 vulnerable example"
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "vulnerable-ec2/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "terraform_app"
    yor_trace            = "286359df-01f5-4f57-8d1b-7c55b74a83e6"
  }
}

resource "aws_security_group" "allow_ssh_from_anywhere" {
  name        = "allow_ssh_from_anywhere"
  description = "Allow SSH inbound traffic from anywhere"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # WORKSHOP: Modify the following line to a CIDR block specific to you, and uncomment the next line with 0.0.0.0
    # This line allows SSH access from any IP address
    #    cidr_blocks      = ["0.0.0.0/0"]
    cidr_blocks = ["186.54.188.72/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name                 = "allow_ssh_from_anywhere"
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "vulnerable-ec2/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "allow_ssh_from_anywhere"
    yor_trace            = "89f8cd0b-9c14-430b-bed5-a724b7ffe23f"
  }
}

resource "aws_security_group" "allow_port_80_from_anywhere" {
  name        = "allow_port_80_from_anywhere"
  description = "Allow port 80 inbound traffic from anywhere"

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # WORKSHOP: Modify the following line to a CIDR block specific to you, and uncomment the next line with 0.0.0.0
    # This line allows HTTP access from any IP address
    #    cidr_blocks      = ["0.0.0.0/0"]
    cidr_blocks = ["186.54.188.72/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name                 = "allow_port_80_from_anywhere"
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "vulnerable-ec2/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "allow_port_80_from_anywhere"
    yor_trace            = "9f408a59-4f68-4feb-8e6e-2a648f3f1a75"
  }
}

data "aws_ami" "amazon2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon2.id
  instance_type               = "t3.nano"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh_from_anywhere.id, aws_security_group.allow_port_80_from_anywhere.id]

  user_data = <<-EOF
    #!/bin/bash
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from the AWS HashiCorp + Snyk Workshop on $(hostname -f)</h1>" > /var/www/html/index.html
  EOF

  # WORKSHOP: Add the name of your key here
  key_name = "mam-workshop-keypair"

  # WORKSHOP: uncomment the lines below to enable encrypted block device
  root_block_device {
    encrypted = true
  }

  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "vulnerable-ec2/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "ec2"
    yor_trace            = "e7a935a5-53ba-410e-a5cc-3427d79c9728"
  }
}

# DynamoDB Table - example
resource "aws_dynamodb_table" "example" {
  name         = "my_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "vulnerable-ec2/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "example"
    yor_trace            = "6c0c73a9-9810-46b1-9810-fc4c2b256fb2"
  }
}

resource "aws_sns_topic" "my_topic" {
  name = "ec2_topic" # Name of the SNS topic
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "vulnerable-ec2/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "my_topic"
    yor_trace            = "f4be8731-2d5f-4e6c-934d-32d0ff34fa96"
  }
}

# Create an email subscription to the SNS topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn # Reference the ARN of the created topic
  protocol  = "email"                    # Use the email protocol
  endpoint  = "estebanpbuday@yahoo.es"   # The email address to subscribe
}