resource "aws_subnet" "main" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_main
  availability_zone = "${var.region}a"

  tags = {
    Name                 = "Main"
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/subnet/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "main"
    yor_trace            = "9abc4e5b-09ea-4710-b644-6eaa6437963f"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_secondary
  availability_zone = "${var.region}c"

  tags = {
    Name                 = "Main"
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/subnet/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "secondary"
    yor_trace            = "a4732e8a-9ae4-4ad8-bd9f-9eee4e5da945"
  }
}
