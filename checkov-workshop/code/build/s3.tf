provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "dev_s3" {
  bucket_prefix = "dev-"
  acl           = "public-read-write"
  tags = {
    git_commit           = "0d4f67750b662ac8b644ed7d2e05c2ade318fe62"
    git_file             = "checkov-workshop/code/build/s3.tf"
    git_last_modified_at = "2025-05-15 15:57:54"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "dev_s3"
    yor_trace            = "5ffa37fd-0b0c-4932-8907-2cdda0a0312e"
  }
}

resource "aws_s3_bucket_ownership_controls" "dev_s3" {
  bucket = aws_s3_bucket.dev_s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
