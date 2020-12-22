variable "region" {
  description = "The AWS Region to deploy to"
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "The AWS profile to deploy to"
}

variable "code_version" {
  description = "The code version to deploy"
}
