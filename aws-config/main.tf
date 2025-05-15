# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      env       = var.environment
      owner     = "Ops"
      version   = var.version_app
      service   = var.application_name
      terraform = "true"
    }
  }

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

resource "aws_config_config_rule" "example" {
  name = "example_rule"

  source {
    owner = "CUSTOM_POLICY"

    source_detail {
      message_type = "ConfigurationItemChangeNotification"
    }

    custom_policy_details {
      policy_runtime = "guard-2.x.x"
      policy_text    = <<EOF
      rule tableisactive when
          resourceType == "AWS::DynamoDB::Table" {
          configuration.tableStatus == ['ACTIVE']
      }

      rule checkcompliance when
          resourceType == "AWS::DynamoDB::Table"
          tableisactive {
              supplementaryConfiguration.ContinuousBackupsDescription.pointInTimeRecoveryDescription.pointInTimeRecoveryStatus == "ENABLED"
      }
EOF                    
    }
  }
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "aws-config/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "example"
    yor_trace            = "b7fb8b55-748f-4a26-8139-6183d095be9f"
  }
}