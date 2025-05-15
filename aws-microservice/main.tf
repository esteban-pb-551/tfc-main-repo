# Configure the AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }

  # Make it faster by skipping something
  # skip_metadata_api_check     = true
  # skip_region_validation      = true
  # skip_credentials_validation = true
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
    Name                 = "${random_pet.this.id}-bus"
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "aws-microservice/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "eventbridge"
    yor_trace            = "de2a346f-7d8a-48ba-9dc1-45d952adbb45"
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
    git_file             = "aws-microservice/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "api_gateway"
    yor_trace            = "2b990186-7e3d-4ff6-bf5a-7f65579f5750"
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
    git_file             = "aws-microservice/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "apigateway_put_events_to_eventbridge_role"
    yor_trace            = "0a003e95-4ff2-4085-8a36-5d45d772c375"
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
    git_file             = "aws-microservice/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "apigateway_put_events_to_eventbridge_policy"
    yor_trace            = "c1e0a098-7313-4843-87de-bd2fc445782f"
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
    git_file             = "aws-microservice/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "dlq"
    yor_trace            = "7d8787de-8b4b-4e13-b57a-02a40fe8bf5a"
  }
}

resource "aws_sqs_queue" "queue" {
  name = random_pet.this.id
  tags = {
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "aws-microservice/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
    yor_name             = "queue"
    yor_trace            = "895d39d5-6b2e-4e3d-8b22-843133d9b0c1"
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