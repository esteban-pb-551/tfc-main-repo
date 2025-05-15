provider "aws" {
  region = "us-west-2"
}

resource "aws_ec2_host" "test" {
  instance_type     = "t3.micro"
  availability_zone = "us-west-2a"

  tags = {
    Environment = "production"
    yor_name    = "test"
    yor_trace   = "7488599a-9d91-4f1d-9592-f9582fda87a8"
  }
}

resource "aws_default" "default" {
  // ...existing configuration...

  tags = {
    Environment = "production"
  }
}