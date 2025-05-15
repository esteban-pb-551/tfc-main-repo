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
    yor_name             = "eventbridge"
    yor_trace            = "b9e267ab-50ae-418b-849c-65b6a5e9c4cb"
    git_commit           = "ee48e3377aa973d5a790c21d9c5f2639968a2d10"
    git_file             = "aws-microservice/main.tf"
    git_last_modified_at = "2025-04-10 11:06:26"
    git_last_modified_by = "estebanpbuday@gmail.com"
    git_modifiers        = "estebanpbuday"
    git_org              = "esteban-pb-551"
    git_repo             = "tfc-main-repo"
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
    yor_trace            = "c0bb2800-1a1b-4b27-8c71-ed9cef2cf0de"
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
    yor_trace            = "642c66f6-8503-4960-8f1b-ca535a028152"
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
    yor_trace            = "773480b5-723b-4005-bd3b-727dfb7e45b3"
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
    yor_trace            = "dd3801b6-b3a4-4233-a932-3e46d78ba665"
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
    yor_trace            = "686b4d02-dce5-4e2f-8c63-f64e9e45a63b"
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