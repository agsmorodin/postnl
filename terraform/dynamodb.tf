module "dynamodb-execution-plans-table-eu-central-1" {
  source = "./execution-plans-table"
  table_count = var.region == "eu-central-1" ? 1 : 0
  tags = local.tags

  # Module will implicitly inherit the base provider
}

module "dynamodb-execution-plans-table-us-east-1" {
  source = "./execution-plans-table"
  table_count = var.region == "eu-central-1" ? 1 : 0
  tags = local.tags

  providers = {
    aws = "aws.us-east-1"
  }
}

resource "aws_dynamodb_global_table" "execution-plans-global-tables" {
  count      = var.region == "eu-central-1" ? 1 : 0

  depends_on = [
    "module.dynamodb-execution-plans-table-eu-central-1",
    "module.dynamodb-execution-plans-table-us-east-1",
  ]

  provider = "aws"

  name     = "execution-plans"

  replica {
    region_name = "eu-central-1"
  }

  replica {
    region_name = "us-east-1"
  }
}
