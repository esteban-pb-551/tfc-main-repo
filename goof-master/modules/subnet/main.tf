resource "aws_subnet" "main" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_main
  availability_zone = "${var.region}a"

  tags = {
    Name                 = "Main"
    git_commit           = "2f8eeb44f70ed9a130044d72f123164debedf21c"
    git_file             = "goof-master/modules/subnet/main.tf"
    git_last_modified_at = "2025-05-15 11:33:54"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "main"
    yor_trace            = "9dc12e3e-df48-4a54-84af-07cb4454f90e"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_secondary
  availability_zone = "${var.region}c"

  tags = {
    Name                 = "Main"
    git_commit           = "2f8eeb44f70ed9a130044d72f123164debedf21c"
    git_file             = "goof-master/modules/subnet/main.tf"
    git_last_modified_at = "2025-05-15 11:33:54"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "secondary"
    yor_trace            = "0d564c65-51dd-4759-ad9e-e66ad8499f85"
  }
}
