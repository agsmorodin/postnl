terraform {
  required_version = "~> 0.14.3"
}

resource "aws_api_gateway_deployment" "api-deploy" {
  depends_on = [
    aws_api_gateway_integration.get-plan-integration,
    aws_api_gateway_method.get-plan,
  ]

  rest_api_id = aws_api_gateway_rest_api.execution-plans.id
  stage_name  = "prod"

  lifecycle {
    create_before_destroy = true
  }
  variables = {
    code_version = var.code_version
    deployed_at = timestamp()
  }
}

resource "aws_api_gateway_rest_api" "execution-plans" {
  name        = local.project_name
  description = "ApiGateway for execution plans"

  endpoint_configuration {
    types = [
      "REGIONAL"]
  }
  tags = local.tags
}
