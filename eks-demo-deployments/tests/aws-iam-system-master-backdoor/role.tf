resource "aws_iam_user" "james_smith" {
  name = "james.smith"
  path = "/users/"
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "eks-demo-deployments/tests/aws-iam-system-master-backdoor/role.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "james_smith"
    yor_trace            = "5f73daa7-674d-4c00-9e97-7f91a9855d19"
  }
}

resource "aws_iam_access_key" "james_smith" {
  user = aws_iam_user.james_smith.name
}

resource "aws_iam_user_policy_attachment" "test_attach_admin" {
  user       = aws_iam_user.james_smith.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# resource "aws_iam_user_policy_attachment" "test_attach_ro" {
#   user       = aws_iam_user.james_smith.name
#   policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
# }

resource "aws_iam_user_policy_attachment" "test_attach_ssm_access" {
  user       = aws_iam_user.james_smith.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}

resource "aws_iam_policy" "ssm_policy" {
  name        = "ssm_admin_access_policy"
  path        = "/"
  description = "Access to all SSM sessions"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ssm:StartSession",
            "ssm:TerminateSession",
            "ssm:ResumeSession",
            "ssm:DescribeSessions",
            "ssm:GetConnectionStatus"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "eks-demo-deployments/tests/aws-iam-system-master-backdoor/role.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "ssm_policy"
    yor_trace            = "c152f83d-cfdb-4250-85cc-7c480f9a9780"
  }
}

output "james_smith_key_id" {
  value = aws_iam_access_key.james_smith.id
}

output "james_smith_secret_key" {
  value     = aws_iam_access_key.james_smith.secret
  sensitive = true
}
