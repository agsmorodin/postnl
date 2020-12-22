// PLANS
resource "aws_api_gateway_resource" "plans" {
   rest_api_id = aws_api_gateway_rest_api.execution-plans.id
   parent_id   = aws_api_gateway_rest_api.execution-plans.root_resource_id
   path_part   = "plans"
}

resource "aws_api_gateway_resource" "plan" {
  rest_api_id = aws_api_gateway_rest_api.execution-plans.id
  parent_id   = aws_api_gateway_resource.plans.id
  path_part   = "{planId}"
}

// PLANS/PLANID
resource "aws_api_gateway_method" "get-plan" {
  rest_api_id   = aws_api_gateway_rest_api.execution-plans.id
  resource_id   = aws_api_gateway_resource.plan.id
  http_method   = "GET"
  authorization = "NONE"
}

//
resource "aws_api_gateway_integration" "get-plan-integration" {
   rest_api_id = aws_api_gateway_rest_api.execution-plans.id
   resource_id = aws_api_gateway_method.get-plan.resource_id
   http_method = aws_api_gateway_method.get-plan.http_method
   uri         = aws_lambda_function.get-execution-plan.invoke_arn
   integration_http_method  = "POST"
   type                     = "AWS_PROXY"
}

resource "aws_api_gateway_method_settings" "get_plan" {
  rest_api_id = aws_api_gateway_rest_api.execution-plans.id
  stage_name  = "prod"
  method_path = "${aws_api_gateway_resource.plans.path_part}/${aws_api_gateway_method.get-plan.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    caching_enabled = false
  }

  depends_on = [aws_api_gateway_deployment.api-deploy]
}
