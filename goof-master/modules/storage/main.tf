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
    yor_trace            = "10a8a43e-72e6-46a5-acd5-b4875069a0da"
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
    yor_trace            = "1ae9f46e-d00e-49f6-8caf-0a6d1f10aa8d"
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
    yor_trace            = "77ed8440-eff9-463e-8a1a-a832d0770348"
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
    yor_trace            = "4b8f75db-3e3b-499b-a8b9-595b9511c842"
  })
}

resource "aws_ssm_parameter" "snyk_ssm_db_host" {
  name        = "/snyk-${var.environment}/DB_HOST"
  description = "Snyk Database"
  type        = "SecureString"
  value       = aws_db_instance.snyk_db.endpoint

  tags = merge(var.default_tags, {}, {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_ssm_db_host"
    yor_trace            = "d08d9033-d92c-4020-9ce5-bf9c1a58c1d3"
  })
}

resource "aws_ssm_parameter" "snyk_ssm_db_password" {
  name        = "/snyk-${var.environment}/DB_PASSWORD"
  description = "Snyk Database Password"
  type        = "SecureString"
  value       = aws_db_instance.snyk_db.password

  tags = merge(var.default_tags, {}, {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_ssm_db_password"
    yor_trace            = "c8906a3a-284a-484e-9048-a0fdb8818032"
  })
}

resource "aws_ssm_parameter" "snyk_ssm_db_user" {
  name        = "/snyk-${var.environment}/DB_USER"
  description = "Snyk Database Username"
  type        = "SecureString"
  value       = aws_db_instance.snyk_db.username

  tags = merge(var.default_tags, {}, {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/storage/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk_ssm_db_user"
    yor_trace            = "9dc64937-e27b-4403-a1ef-c546a8398840"
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
    yor_trace            = "dec7bba1-0c76-4d71-9e5d-a7cc485564da"
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
    yor_trace            = "6211b7c9-7e45-43d8-b441-c88e58c4a5f9"
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
    yor_trace            = "94bd1cb2-5514-4b3f-a654-9e3d2437809d"
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
