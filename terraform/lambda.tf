# Lambda
resource "aws_lambda_function" "get-execution-plan" {
  function_name = "get-${local.lambda_name}"

  s3_bucket     = local.lambda_s3_bucket
  s3_key        = "lambda-${var.code_version}.zip"

  handler = "src/index.handleGetHttp"
  runtime = "nodejs12.x"

  memory_size = "512"
  timeout = "30"
  environment {
    variables = {
      CODE_VERSION               = var.code_version
      EXECUTION_PLANS_TABLE_NAME = "execution-plans"
    }
  }

  tracing_config {
    mode = "Active"
  }

  role = aws_iam_role.lambda_exec.arn
  depends_on    = [aws_iam_role_policy_attachment.lambda_logs, aws_cloudwatch_log_group.execution_plans_log_group]
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

resource "aws_lambda_function" "post-execution-plan" {
  function_name = "post-${local.lambda_name}"

  s3_bucket     = local.lambda_s3_bucket
  s3_key        = "lambda-${var.code_version}.zip"

  handler = "src/index.handleSQS"
  runtime = "nodejs12.x"

  memory_size = "512"
  timeout = "30"
  environment {
    variables = {
      GIT_COMMIT                            = var.code_version
      EXECUTION_PLANS_TABLE_NAME            = "execution-plans"
    }
  }

  tracing_config {
    mode = "Active"
  }

  role = aws_iam_role.lambda_exec.arn
  depends_on    = [aws_iam_role_policy_attachment.lambda_logs, aws_cloudwatch_log_group.execution_plans_log_group]
  tags = local.tags
}

resource "aws_lambda_permission" "allows_sqs_to_trigger_lambda" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post-execution-plan.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.plans_queue.arn
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  batch_size       = 1
  event_source_arn =  aws_sqs_queue.plans_queue.arn
  enabled          = true
  function_name    =  aws_lambda_function.post-execution-plan.arn
  depends_on = [aws_iam_role_policy.lambda_policy]
}
