# Dead-Letter Queue: holds messages that fail to process after maxReceiveCount
resource "aws_sqs_queue" "dlq" {
  name                      = "my-app-dead-letter-queue"                   # Unique queue name
  message_retention_seconds = 1209600                                       # Retain DLQ messages for 14 days
  tags = {                                                                   
    Environment = "dev"                                                      
    Project     = "example-app"                                              
  }
}

# Primary Queue: main FIFO or standard queue
resource "aws_sqs_queue" "main" {
  name                       = "my-app-queue"                                # Unique queue name
  delay_seconds              = 0                                             # No initial delay :contentReference[oaicite:0]{index=0}
  max_message_size           = 262144                                        # Up to 256 KB :contentReference[oaicite:1]{index=1}
  message_retention_seconds  = 345600                                        # Retain for 4 days :contentReference[oaicite:2]{index=2}
  receive_wait_time_seconds  = 0                                             # No long polling :contentReference[oaicite:3]{index=3}
  visibility_timeout_seconds = 30                                            # 30-second visibility timeout :contentReference[oaicite:4]{index=4}

  # Enable server-side encryption (SSE) with a KMS key
  kms_master_key_id = aws_kms_key.sqs_key.arn                                # KMS key ARN :contentReference[oaicite:5]{index=5}

  # Attach a dead-letter queue for failed messages
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn                              # DLQ ARN :contentReference[oaicite:6]{index=6}
    maxReceiveCount     = 5                                                  # Retry up to 5 times :contentReference[oaicite:7]{index=7}
  })

  tags = {
    Environment = "dev"                                                     # Cost-allocation tag :contentReference[oaicite:8]{index=8}
    Project     = "example-app"                                             
  }
}

# Optional: KMS Key for encryption
resource "aws_kms_key" "sqs_key" {
  description             = "KMS key for SQS queue encryption"
  deletion_window_in_days = 10
  tags = {
    Environment = "dev"                                                     # Tagging KMS key :contentReference[oaicite:9]{index=9}
    Project     = "example-app"                                             
  }
}
