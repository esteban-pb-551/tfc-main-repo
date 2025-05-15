resource "aws_s3_bucket" "data" {
  # bucket is public
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "${local.resource_prefix.value}-data"
  force_destroy = true

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_s3.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "data"
    yor_trace            = "b3c05fbb-7f03-4000-8f3a-04926c11394b"
  }
}

resource "aws_s3_bucket_object" "data_object" {
  bucket = aws_s3_bucket.data.id
  key    = "customer-master.xlsx"
  source = "resources/customer-master.xlsx"

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_s3.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "data_object"
    yor_trace            = "3f31d019-4572-4b9a-8834-05218d60b978"
  }
}

resource "aws_s3_bucket" "financials" {
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "${local.resource_prefix.value}-financials"
  acl           = "private"
  force_destroy = true

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_s3.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "financials"
    yor_trace            = "814de3f4-f08a-4c92-ade7-2c36fc7b8684"
  }
}

resource "aws_s3_bucket" "operations" {
  # bucket is not encrypted
  # bucket does not have access logs
  bucket = "${local.resource_prefix.value}-operations"
  acl    = "private"
  versioning {
    enabled = true
  }
  force_destroy = true

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_s3.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "operations"
    yor_trace            = "35b1e326-a5c1-4843-af60-e3a309a74324"
  }
}

resource "aws_s3_bucket" "data_science" {
  # bucket is not encrypted
  bucket = "${local.resource_prefix.value}-data-science"
  acl    = "private"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = "${aws_s3_bucket.logs.id}"
    target_prefix = "log/"
  }
  force_destroy = true

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_s3.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "data_science"
    yor_trace            = "dfada2a6-1160-4ade-b93c-c18ddbfc7046"
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "${local.resource_prefix.value}-logs"
  acl    = "log-delivery-write"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "${aws_kms_key.logs_key.arn}"
      }
    }
  }
  force_destroy = true

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_s3.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "logs"
    yor_trace            = "1012300d-d7fd-47cc-83a6-6844bb46f0b8"
  }
}
