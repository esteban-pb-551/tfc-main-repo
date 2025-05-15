provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "dev_s3" {
  bucket_prefix = "dev-"

  tags = {
    Environment          = "Dev"
    git_commit           = "7d66bc92fddceb3edcb10242e12db7cbf7b163ec"
    git_file             = "checkov-workshop/code/build/s3.tf"
    git_last_modified_at = "2025-05-15 12:00:57"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "dev_s3"
    yor_trace            = "1c69738d-93ae-4f86-a98a-f23b169dfa09"
  }
}

resource "aws_s3_bucket_ownership_controls" "dev_s3" {
  bucket = aws_s3_bucket.dev_s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
