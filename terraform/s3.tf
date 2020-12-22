resource "aws_s3_bucket" "execution-plans-lambdas" {
  bucket = "execution-plans-lambdas"
  acl    = "private"

  tags = local.tags
}
