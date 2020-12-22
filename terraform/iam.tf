resource "aws_iam_role" "lambda_exec" {
   name = "${local.project_name}-lambda-exec-${var.region}"
   tags = local.tags

   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
 }

resource "aws_iam_policy" "db_policy" {
  name        = "${local.project_name}-lambda-global-dynamodb-policy-${var.region}"
  description = "Allows the ${local.project_name} to access execution-plans DynamoDB table."

  policy     = data.aws_iam_policy_document.dynamodb_plans_permissions_policy_document.json
}

resource "aws_iam_policy_attachment" "task_policy_execution-plans-dynamodb_attachment" {
  name       = "${local.project_name}-lambda-global-dynamodb-policy-${var.region}"
  roles      = [aws_iam_role.lambda_exec.id]
  policy_arn = aws_iam_policy.db_policy.arn
}

resource "aws_iam_role_policy" "lambda_xray_policy" {
  name = "lambda_xray_policy"
  role = aws_iam_role.lambda_exec.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "xray:PutTraceSegments",
            "xray:PutTelemetryRecords",
            "xray:GetSamplingRules",
            "xray:GetSamplingTargets",
            "xray:GetSamplingStatisticSummaries"
          ],
          "Resource": [
              "*"
          ]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_exec.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ChangeMessageVisibility"
      ],
      "Resource": "${aws_sqs_queue.plans_queue.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sqs:ListQueues"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

# SNS
resource "aws_iam_role" "sns_log" {
  name = "${local.project_name}-sns-log-${var.region}"
  tags = local.tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "sns_policy" {
  name = "sns_policy"
  role = aws_iam_role.sns_log.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}