module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "rust-aws-lambda"
  description   = "Create an AWS Lambda in Rust with Terraform"
  runtime       = "provided.al2023"
  architectures = ["arm64"]
  handler       = "bootstrap"

  create_package         = false
  local_existing_package = "./target/lambda/rust-example/bootstrap.zip"
  tags = {
    git_commit           = "25eea43527881acd9e9a5a8fb141d5aa4b48417a"
    git_file             = "rust-example/rust_lambda.tf"
    git_last_modified_at = "2025-04-10 10:29:50"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "lambda_function"
    yor_trace            = "eb7a094e-9ff9-4206-9415-2809c8804bbe"
  }
}