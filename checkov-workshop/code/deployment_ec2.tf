resource "aws_instance" "web_host" {
  # ec2 have plain text secrets in user data
  ami           = "${var.ami}"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
  "${aws_security_group.web-node.id}"]
  subnet_id = "${aws_subnet.web_subnet.id}"
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMAAA
export AWS_SECRET_ACCESS_KEY=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
export AWS_DEFAULT_REGION=us-west-2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "web_host"
    yor_trace            = "30560905-cc63-4afd-9bfd-643834cabeed"
  }
}

resource "aws_ebs_volume" "web_host_storage" {
  # unencrypted volume
  availability_zone = "${var.region}a"
  #encrypted         = false  # Setting this causes the volume to be recreated on apply 
  size = 1

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "web_host_storage"
    yor_trace            = "e8d49e0f-dbd6-40b9-9d6f-f70def2adee8"
  }
}

resource "aws_ebs_snapshot" "example_snapshot" {
  # ebs snapshot without encryption
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  description = "${local.resource_prefix.value}-ebs-snapshot"

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "example_snapshot"
    yor_trace            = "35814362-ac2e-4fa4-9571-083446aeee6b"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.web_host_storage.id}"
  instance_id = "${aws_instance.web_host.id}"
}

resource "aws_security_group" "web-node" {
  # security group is open to the world in SSH port
  name        = "${local.resource_prefix.value}-sg"
  description = "${local.resource_prefix.value} Security Group"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  depends_on = [aws_vpc.web_vpc]

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "web-node"
    yor_trace            = "3a3690aa-cbaa-43c0-aa6e-ea9abb44c99d"
  }
}

resource "aws_vpc" "web_vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "web_vpc"
    yor_trace            = "c19b0b14-3e52-4eb4-ade3-348b6e15ef68"
  }
}

resource "aws_subnet" "web_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true


  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "web_subnet"
    yor_trace            = "7b447ce9-91ba-41f0-8dff-e4aaa7c41ff9"
  }
}

resource "aws_subnet" "web_subnet2" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "172.16.11.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true


  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "web_subnet2"
    yor_trace            = "a4cc4fb8-02bc-4e6a-bd7a-e3949781b8a1"
  }
}


resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id


  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "web_igw"
    yor_trace            = "da08dbf2-3166-4efb-99be-0cea20ebd58a"
  }
}

resource "aws_route_table" "web_rtb" {
  vpc_id = aws_vpc.web_vpc.id


  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "web_rtb"
    yor_trace            = "b8b7168d-3a9e-4579-8d6e-4b80ba8fdcde"
  }
}

resource "aws_route_table_association" "rtbassoc" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route_table_association" "rtbassoc2" {
  subnet_id      = aws_subnet.web_subnet2.id
  route_table_id = aws_route_table.web_rtb.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.web_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_igw.id

  timeouts {
    create = "5m"
  }
}

resource "aws_network_interface" "web-eni" {
  subnet_id   = aws_subnet.web_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "web-eni"
    yor_trace            = "e84e7e7c-562f-46cb-9516-6e3bdd2db81e"
  }
}

# VPC Flow Logs to S3
resource "aws_flow_log" "vpcflowlogs" {
  log_destination      = aws_s3_bucket.flowbucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.web_vpc.id


  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "vpcflowlogs"
    yor_trace            = "7dd760bd-561c-4eb7-a4f7-32cbc321fdf3"
  }
}

resource "aws_s3_bucket" "flowbucket" {
  bucket        = "${local.resource_prefix.value}-flowlogs"
  force_destroy = true

  tags = {
    git_commit           = "ab899ca8d43cdbf5844e8d4cc934c6cd8aece3e8"
    git_file             = "checkov-workshop/code/deployment_ec2.tf"
    git_last_modified_at = "2025-05-14 19:08:30"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "flowbucket"
    yor_trace            = "3ae03673-7488-4add-8994-340a185ec52c"
  }
}

# OUTPUTS
output "ec2_public_dns" {
  description = "Web Host Public DNS name"
  value       = aws_instance.web_host.public_dns
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.web_vpc.id
}

output "public_subnet" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet.id
}

output "public_subnet2" {
  description = "The ID of the Public subnet"
  value       = aws_subnet.web_subnet2.id
}
