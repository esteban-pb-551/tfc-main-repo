provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      environment = "production"
      owner       = "Ops"
      version     = "1.0.0"
    }
  }
}

resource "aws_ec2_host" "test" {
  instance_type     = "t3.micro"
  availability_zone = "us-west-2a"

  tags = {
    Environment = "production"
  }
}