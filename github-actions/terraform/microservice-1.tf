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
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "github-actions/terraform/microservice-1.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "basic-dynamodb-table"
    yor_trace            = "a60310a2-1bfa-4a13-b13a-020e08a2b655"
  }
}