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
    yor_trace            = "27d4dd45-4048-46e1-8f0c-04f9a6202bdd"
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
    yor_trace            = "e1c04ce5-afb9-4fae-ac90-e1810eefd025"
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
    yor_trace            = "3f943d46-88b8-4bc5-a997-720cc4fd622d"
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
    yor_trace            = "4357f364-e0c8-4f79-b3db-1c5a9c8ba500"
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
    yor_trace            = "2543b6d9-f15f-4f4a-b4c0-284f33fb6f81"
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
    yor_trace            = "4b89c3f6-bdd0-42c1-94a5-73c4590fcf25"
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
    yor_trace            = "c48995f2-1426-4339-8918-44ec45479b3b"
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
    yor_trace            = "c23214c3-2664-4cfb-b9cf-05acf15e8fc9"
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
    yor_trace            = "c8421276-787e-403a-aa87-607fd7589007"
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
    yor_trace            = "c4a6d386-623b-41e8-a1eb-5a6511816e24"
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
    yor_trace            = "dcac566d-e42a-45c2-a8a8-7565579fe025"
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
    yor_trace            = "42e4ed86-7382-4858-b5ad-4447c1e6bc69"
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
