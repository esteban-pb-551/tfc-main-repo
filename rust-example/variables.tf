# The region is specified in  GitHub - settings/variables/actions
variable "application_name" {
  type        = string
  description = "The name of the application"
  default     = "rust-sample-app"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
  default     = "test"
}

variable "version_app" {
  type        = string
  description = "The version of the application"
  default     = "0.1.0"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the application"
  default     = "us-east-1"
}

variable "AWS_SESSION_TOKEN" {
  description = "AWS session token"
  type        = string
  default     = ""
  sensitive   = true
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key ID"
  type        = string
  default     = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret access key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "gemini_api_key" {
  description = "Gemini API Key for Lambda"
  type        = string
  sensitive   = true
}