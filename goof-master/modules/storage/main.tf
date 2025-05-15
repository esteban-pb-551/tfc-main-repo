resource "aws_db_subnet_group" "snyk_rds_subnet_grp" {
  name       = "snyk_rds_subnet_grp_${var.environment}"
  subnet_ids = var.private_subnet

  tags = merge(var.default_tags, {
    Name = "snyk_rds_subnet_grp_${var.environment}"
    }, {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_rds_subnet_grp"
    yor_trace            = "39e9995a-c345-458c-b43e-a287d08a6724"
  })
}

resource "aws_security_group" "snyk_rds_sg" {
  name   = "snyk_rds_sg"
  vpc_id = var.vpc_id

  tags = merge(var.default_tags, {
    Name = "snyk_rds_sg_${var.environment}"
    }, {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_rds_sg"
    yor_trace            = "1faf9f98-03bb-4a42-aac9-82006177b7a3"
  })

  # HTTP access from anywhere
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_kms_key" "snyk_db_kms_key" {
  description             = "KMS Key for DB instance ${var.environment}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = merge(var.default_tags, {
    Name = "snyk_db_kms_key_${var.environment}"
    }, {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_db_kms_key"
    yor_trace            = "08920493-75c9-4ebc-810d-a790d6ac7200"
  })
}

resource "aws_db_instance" "snyk_db" {
  allocated_storage         = 20
  engine                    = "postgres"
  engine_version            = "10.20"
  instance_class            = "db.t3.micro"
  storage_type              = "gp2"
  password                  = var.db_password
  username                  = var.db_username
  vpc_security_group_ids    = [aws_security_group.snyk_rds_sg.id]
  db_subnet_group_name      = aws_db_subnet_group.snyk_rds_subnet_grp.id
  identifier                = "snyk-db-${var.environment}"
  storage_encrypted         = true
  skip_final_snapshot       = true
  final_snapshot_identifier = "snyk-db-${var.environment}-db-destroy-snapshot"
  kms_key_id                = aws_kms_key.snyk_db_kms_key.arn
  tags = merge(var.default_tags, {
    Name = "snyk_db_${var.environment}"
    }, {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_db"
    yor_trace            = "785bc812-4044-4632-898b-160678606ac0"
  })
}

resource "aws_ssm_parameter" "snyk_ssm_db_host" {
  name        = "/snyk-${var.environment}/DB_HOST"
  description = "Snyk Database"
  type        = "SecureString"
  value       = aws_db_instance.snyk_db.endpoint

  tags = merge(var.default_tags, {}, {
    git_commit           = "2f8eeb44f70ed9a130044d72f123164debedf21c"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-05-15 11:33:54"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_ssm_db_host"
    yor_trace            = "6d68bba6-5266-49c6-b3ec-953f4d136260"
  })
}

resource "aws_ssm_parameter" "snyk_ssm_db_password" {
  name        = "/snyk-${var.environment}/DB_PASSWORD"
  description = "Snyk Database Password"
  type        = "SecureString"
  value       = aws_db_instance.snyk_db.password

  tags = merge(var.default_tags, {}, {
    git_commit           = "2f8eeb44f70ed9a130044d72f123164debedf21c"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-05-15 11:33:54"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_ssm_db_password"
    yor_trace            = "9cb701fe-c4d9-4d4e-b4f1-1522f7d94821"
  })
}

resource "aws_ssm_parameter" "snyk_ssm_db_user" {
  name        = "/snyk-${var.environment}/DB_USER"
  description = "Snyk Database Username"
  type        = "SecureString"
  value       = aws_db_instance.snyk_db.username

  tags = merge(var.default_tags, {}, {
    git_commit           = "2f8eeb44f70ed9a130044d72f123164debedf21c"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-05-15 11:33:54"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_ssm_db_user"
    yor_trace            = "5ff08927-17f6-4077-9590-1bae73c395a8"
  })
}
resource "aws_ssm_parameter" "snyk_ssm_db_name" {
  name        = "/snyk-${var.environment}/DB_NAME"
  description = "Snyk Database Name"
  type        = "SecureString"
  value       = "snyk_db_${var.environment}"

  tags = merge(var.default_tags, {
    environment = "${var.environment}"
    }, {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_ssm_db_name"
    yor_trace            = "b0c3cfd4-2804-41fe-be6f-0435c8e1aa52"
  })
}

resource "aws_s3_bucket" "snyk_storage" {
  bucket = "snyk-storage-${var.environment}-demo"
  tags = merge(var.default_tags, {
    name = "snyk_blob_storage_${var.environment}"
    }, {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_storage"
    yor_trace            = "ce596cab-d2b8-4b92-b22b-ed188f0afe8a"
  })
}

resource "aws_s3_bucket" "my-new-undeployed-bucket" {
  bucket = "snyk-public-${var.environment}-demo"
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "my-new-undeployed-bucket"
    yor_trace            = "3a00ec74-2192-4241-8bc4-8f102ef323b4"
  }
}

resource "aws_s3_bucket_public_access_block" "snyk_public" {
  bucket = aws_s3_bucket.my-new-undeployed-bucket.id

  block_public_acls   = false
  ignore_public_acls  = var.public_ignore_acl
  block_public_policy = var.public_policy_control
}

resource "aws_s3_bucket_public_access_block" "snyk_private" {
  bucket = aws_s3_bucket.snyk_storage.id

  ignore_public_acls  = true
  block_public_acls   = true
  block_public_policy = true
}
