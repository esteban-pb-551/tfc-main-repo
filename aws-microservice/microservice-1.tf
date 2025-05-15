# DynamoDB Table
resource "random_pet" "table_name" {
  prefix    = "orders"
  separator = "_"
  length    = 4
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = random_pet.table_name.id
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "SourceOrderID"
  range_key      = "SourceItemID"

  attribute {
    name = "SourceOrderID"
    type = "S"
  }

  attribute {
    name = "SourceItemID"
    type = "S"
  }
  tags = {
    "Name"               = "dynamodb-table-1"
    "Environment"        = "production"
    "Project"            = "${var.default_tags.project}"
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "aws-microservice/microservice-1.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "basic-dynamodb-table"
    yor_trace            = "1b5123a2-069b-47a4-bc23-9d624690b5f9"
  }
}