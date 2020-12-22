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
