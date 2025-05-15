# Configure the AWS Provider
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
  description = "Terraform application for SNS project"
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "00-base-aws/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "terraform_app"
    yor_trace            = "3be7d625-d2c6-4e74-8347-61ada6e84264"
  }
}

# Create an SNS topic
resource "aws_sns_topic" "my_topic" {
  name = "my_topic" # Name of the SNS topic
  tags = {
    git_commit           = "2f8eeb44f70ed9a130044d72f123164debedf21c"
    git_file             = "00-base-aws/main.tf"
    git_last_modified_at = "2025-05-15 11:33:54"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "my_topic"
    yor_trace            = "3200fa59-be90-480b-9e77-8a80d506c699"
  }
}

# Create an email subscription to the SNS topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn # Reference the ARN of the created topic
  protocol  = "email"                    # Use the email protocol
  endpoint  = "estebanpbuday@yahoo.es"   # The email address to subscribe
}