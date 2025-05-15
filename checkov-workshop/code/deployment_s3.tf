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
    yor_trace            = "da7253e0-72a3-46ab-98d7-634a07c7c02b"
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
    yor_trace            = "68569959-8eb8-4630-8712-d01050384877"
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
    yor_trace            = "992440f0-943f-4ad0-99e6-d3f98f894a49"
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
    yor_trace            = "a9b84f4d-1f6c-434c-93b7-a919b778144b"
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
    yor_trace            = "92e53595-4ee1-4f4d-b665-cb12d5999f0a"
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
    yor_trace            = "7734c3b5-e605-4336-b195-6271752493f7"
  }
}
