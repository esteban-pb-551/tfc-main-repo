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
  description = "Terraform sample of Rust application"
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "rust-example/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "terraform_app"
    yor_trace            = "dab8035d-6d60-463c-9998-3afb6a997f8f"
  }
}