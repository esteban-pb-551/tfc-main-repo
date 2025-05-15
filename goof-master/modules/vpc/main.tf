resource "aws_vpc" "example" {
  cidr_block = var.cidr
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/vpc/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "example"
    yor_trace            = "d2808c6e-a6e5-458e-af0d-754232eabc7c"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.example.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/vpc/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "default"
    yor_trace            = "49cf61bd-b8c5-434d-b39a-ed9cb4eee271"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound from anywhere"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/vpc/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "allow_ssh"
    yor_trace            = "6f55e65f-8c01-44e9-9d94-1cc39a140646"
  }
}

resource "aws_security_group" "allow_ssh_with_valid_cidr" {
  name        = "allow_ssh_with_valid_cidr"
  description = "Allow SSH inbound from specific range"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = tolist([var.cidr])
  }
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/vpc/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "allow_ssh_with_valid_cidr"
    yor_trace            = "feceed50-8254-4faf-adac-3273c7837d86"
  }
}
