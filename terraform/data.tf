data "aws_iam_policy_document" "dynamodb_plans_permissions_policy_document" {
  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:Scan",
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem"]
    resources = [
      "arn:aws:dynamodb:${var.region}:${var.aws_profile}:table/execution-plans"
    ]
    effect = "Allow"
  }
}
