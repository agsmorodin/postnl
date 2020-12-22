resource "aws_sns_topic" "execution-plans-topic" {
  name = "execution-plans-topic"
  sqs_failure_feedback_role_arn = aws_iam_role.sns_log.arn
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.execution-plans-topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.plans_queue.arn
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = aws_sqs_queue.plans_queue.id
  policy = data.aws_iam_policy_document.sqs_upload.json
}

data "aws_iam_policy_document" "sqs_upload" {
  statement {
    actions = [
      "sqs:SendMessage",
    ]
    condition {
      test = "ArnEquals"
      variable = "aws:SourceArn"

      values = [
        aws_sns_topic.execution-plans-topic.arn,
      ]
    }
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "*"]
    }
    resources = [
      aws_sqs_queue.plans_queue.arn,
    ]
  }
}
