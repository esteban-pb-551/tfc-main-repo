# Configure Terraform Cloud
terraform {
  cloud {

    organization = "aws-workshop-lep511"

    workspaces {
      name = "learn-terraform-github-actions"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  default_tags {
    tags = {
      environment     = "Test"
      owner           = "Ops"
      applicationName = var.application_name
      awsApplication  = aws_servicecatalogappregistry_application.terraform_app.application_tag.awsApplication
    }
  }

  # Make it faster by skipping something
  # skip_metadata_api_check     = true
  # skip_region_validation      = true
  # skip_credentials_validation = true
}

# Create application using aliased 'application' provider
provider "aws" {
  alias = "application"
}

# Register new application
# An AWS Service Catalog AppRegistry Application is displayed in the AWS Console under "MyApplications".
resource "aws_servicecatalogappregistry_application" "terraform_app" {
  provider    = aws.application
  name        = var.application_name
  description = "New sample terraform application"
  tags = {
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "github-actions/terraform/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "terraform_app"
    yor_trace            = "ca820661-3b3a-48fc-87f2-eb1d6ef631df"
  }
}


module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "${random_pet.this.id}-bus"

  attach_sqs_policy = true
  sqs_target_arns = [
    aws_sqs_queue.queue.arn,
    aws_sqs_queue.dlq.arn
  ]

  rules = {
    orders_create = {
      description = "Capture all created orders",
      event_pattern = jsonencode({
        "detail-type" : ["Order Create"],
        "source" : ["api.gateway.orders.create"]
      })
    }
  }

  targets = {
    orders_create = [
      {
        name            = "send-orders-to-sqs"
        arn             = aws_sqs_queue.queue.arn
        dead_letter_arn = aws_sqs_queue.dlq.arn
        target_id       = "send-orders-to-sqs"
      }
    ]
  }
  tags = {
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "github-actions/terraform/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "eventbridge"
    yor_trace            = "ba118ed6-4c8a-49bf-b061-9bf0246c0da2"
  }
}


##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 4.0"

  name          = "${random_pet.this.id}-http"
  description   = "My ${random_pet.this.id} HTTP API Gateway"
  protocol_type = "HTTP"

  create_api_domain_name = false

  integrations = {
    "POST /orders/create" = {
      integration_type    = "AWS_PROXY"
      integration_subtype = "EventBridge-PutEvents"
      credentials_arn     = module.apigateway_put_events_to_eventbridge_role.iam_role_arn

      request_parameters = jsonencode({
        EventBusName = module.eventbridge.eventbridge_bus_name,
        Source       = "api.gateway.orders.create",
        DetailType   = "Order Create",
        Detail       = "$request.body",
        Time         = "$context.requestTimeEpoch"
      })

      payload_format_version = "1.0"
    }
  }
  tags = {
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "github-actions/terraform/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "api_gateway"
    yor_trace            = "0e2b5168-4bf2-4b97-8ed3-1c7dce6a8662"
  }
}

module "apigateway_put_events_to_eventbridge_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.0"

  create_role = true

  role_name         = "apigateway-put-events-to-eventbridge"
  role_requires_mfa = false

  trusted_role_services = ["apigateway.amazonaws.com"]

  custom_role_policy_arns = [
    module.apigateway_put_events_to_eventbridge_policy.arn
  ]
  tags = {
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "github-actions/terraform/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "apigateway_put_events_to_eventbridge_role"
    yor_trace            = "e8ea5da0-ce61-44c3-a9ef-692f966a7b07"
  }
}

module "apigateway_put_events_to_eventbridge_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 4.0"

  name        = "apigateway-put-events-to-eventbridge"
  description = "Allow PutEvents to EventBridge"

  policy = data.aws_iam_policy_document.apigateway_put_events_to_eventbridge_policy.json
  tags = {
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "github-actions/terraform/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "apigateway_put_events_to_eventbridge_policy"
    yor_trace            = "6fe4078b-97f2-416e-bc88-8f75325a92aa"
  }
}

data "aws_iam_policy_document" "apigateway_put_events_to_eventbridge_policy" {
  statement {
    sid       = "AllowPutEvents"
    actions   = ["events:PutEvents"]
    resources = [module.eventbridge.eventbridge_bus_arn]
  }

  depends_on = [module.eventbridge]
}

resource "aws_sqs_queue" "dlq" {
  name = "${random_pet.this.id}-dlq"
  tags = {
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "github-actions/terraform/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "dlq"
    yor_trace            = "62e0baa8-a839-4605-827b-e9bd70cc34d3"
  }
}

resource "aws_sqs_queue" "queue" {
  name = random_pet.this.id
  tags = {
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "github-actions/terraform/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "queue"
    yor_trace            = "4c5d9c1e-1851-48c5-b876-0a8de43c83b2"
  }
}

resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id
  policy    = data.aws_iam_policy_document.queue.json
}

data "aws_iam_policy_document" "queue" {
  statement {
    sid     = "AllowSendMessage"
    actions = ["sqs:SendMessage"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sqs_queue.queue.arn]
  }
}