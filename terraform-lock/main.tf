provider "aws" {
  region     = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "execution-plans-state-bucket"
    key = "terraform"
    region = "eu-central-1"
  }
}

resource "aws_dynamodb_table" "terraform-locks" {
  name           = "terraform-locks"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
