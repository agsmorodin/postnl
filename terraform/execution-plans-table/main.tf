resource "aws_dynamodb_table" "execution-plans" {
  count          =  var.table_count
  name           = "execution-plans"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "planId"

  # DynamoDB Stream must be enabled
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "planId"
    type = "S"
  }
  tags = var.tags
}
