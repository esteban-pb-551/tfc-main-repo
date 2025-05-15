provider "aws" {
  region = "us-west-2"
}

resource "aws_ec2_host" "test" {
  instance_type     = "t3.micro"
  availability_zone = "us-west-2a"

  tags = {
    Environment          = "production"
    git_commit           = "61921ebe0b485b2ca256095c7afa4affea268e02"
    git_file             = "checkov-workshop/code/simple_ec2.tf"
    git_last_modified_at = "2025-05-15 11:13:55"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "test"
    yor_trace            = "ed65d5b4-7703-4d97-bedb-d90e925c3a48"
  }
}

resource "aws_default" "default" {
  // ...existing configuration...

  tags = {
    Environment = "production"
  }
}