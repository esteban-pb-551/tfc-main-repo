provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "dev_s3" {
  bucket_prefix = "dev-"

  tags = {
    Environment          = "Dev"
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/simple_s3.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "dev_s3"
    yor_trace            = "8a22defa-2b48-4b72-8ff1-427897351b18"
  }
}


