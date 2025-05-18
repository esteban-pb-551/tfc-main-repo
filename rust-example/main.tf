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
  alias = "application"
  region = var.aws_region
}

# Register new application
# An AWS Service Catalog AppRegistry Application is displayed in the AWS Console under "MyApplications".
resource "aws_servicecatalogappregistry_application" "terraform_app" {
  provider    = aws.application
  name        = var.application_name
  description = "Terraform sample of Rust application"
}

# Create a bucket with suffix agent- and version enabled
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "agent-${random_pet.random_bucket_suffix.id}"
  
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

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "random_pet" "random_bucket_suffix" {
  length    = 2
  separator = "-"
}