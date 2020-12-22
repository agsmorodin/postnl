resource "aws_cloudwatch_log_group" "execution_plans_log_group" {
  name              = "/aws/lambda/${local.lambda_name}"
  retention_in_days = 14
  tags = local.tags
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${local.lambda_name}-lambda-logging"
  path        = "/"
  description = "IAM policy for logging from an execution plans Lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
