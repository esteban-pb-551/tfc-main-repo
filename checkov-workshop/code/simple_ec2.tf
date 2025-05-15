provider "aws" {
  region = "us-west-2"
}

resource "aws_ec2_host" "test" {
  instance_type     = "t3.micro"
  availability_zone = "us-west-2a"

  tags = {
    Environment = "production"
  }
}

resource "aws_default" "default" {
  // ...existing configuration...

  tags = {
    Environment = "production"
  }
}