# Lambda
resource "aws_lambda_function" "get-execution-plan" {
  function_name = local.lambda_name

  s3_bucket     = local.lambda_s3_bucket
  s3_key        = "lambda-${var.code_version}.zip"

  handler = "src/index.handler"
  runtime = "nodejs12.x"

  memory_size = "512"
  timeout = "30"
  environment {
    variables = {
      GIT_COMMIT                            = var.code_version
      EXECUTION_PLANS_TABLE_NAME            = "execution-plans"
    }
  }

  role = aws_iam_role.lambda_exec.arn
  depends_on    = ["aws_iam_role_policy_attachment.lambda_logs", "aws_cloudwatch_log_group.execution_plans_log_group"]
  tags = local.tags
}

resource "aws_lambda_permission" "apigw_plans" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.get-execution-plan.function_name
   principal     = "apigateway.amazonaws.com"
   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.execution-plans.execution_arn}/*/*"
 }
