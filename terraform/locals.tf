locals {
  tags = {
      project = "execution-plans"
  }

  lambda_s3_bucket = "execution-plans-lambdas"

  lambda_name = "execution-plan-${var.region}"

  project_name = "execution-plans"
}
