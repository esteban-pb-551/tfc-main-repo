data "aws_iam_policy_document" "admin-assume-role-policy" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "snyk-admin-role" {
  name                = "snyk_${var.environment}_role"
  assume_role_policy  = data.aws_iam_policy_document.admin-assume-role-policy.json # (not shown)
  managed_policy_arns = []
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "goof-master/modules/iam/main.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "snyk-admin-role"
    yor_trace            = "946671ea-371d-4931-bf81-7895b8713dd8"
  }
}
