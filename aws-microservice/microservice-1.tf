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
    "Name"        = "dynamodb-table-1"
    "Environment" = "production"
    "Project"     = "${var.default_tags.project}"
    yor_name      = "basic-dynamodb-table"
    yor_trace     = "1bfd0832-0260-4a29-b306-42b002354b3a"
  }
}