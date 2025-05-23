module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "rust-aws-lambda"
  description   = "Create an AWS Lambda in Rust with Terraform"
  runtime       = "provided.al2023"
  architectures = ["arm64"]
  handler       = "bootstrap"
  timeout       = 180

  create_package         = false
  local_existing_package = "./target/lambda/rust-example/bootstrap.zip"
  environment_variables = {
    GEMINI_API_KEY = var.gemini_api_key
  }
}