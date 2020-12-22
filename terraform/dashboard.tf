resource "aws_cloudwatch_dashboard" "execution_plans" {
  dashboard_name = "execution_plans"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [
            "AWS/SNS",
            "NumberOfMessagesPublished",
            "TopicName",
            "execution-plans-topic"
          ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "SNS: Published plans"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [
            "AWS/SNS",
            "NumberOfNotificationsFailed",
            "TopicName",
            "execution-plans-topic"
          ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "SNS: Failed plans"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [
            "AWS/SQS",
            "NumberOfMessagesSent",
            "QueueName",
            "plans_queue"
          ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "SQS: received plans"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [ "AWS/SQS", "NumberOfMessagesDeleted", "QueueName", "plans_queue" ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "SQS: processed plans"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [ "AWS/Lambda", "Invocations", "FunctionName", "post-execution-plan-eu-central-1" ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "POST lambda: invocations"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [ "AWS/Lambda", "Errors", "FunctionName", "post-execution-plan-eu-central-1" ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "POST lambda: errors"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [ "AWS/Lambda", "Errors", "FunctionName", "post-execution-plan-eu-central-1" ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "POST lambda: errors"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [ "AWS/ApiGateway", "Latency", "ApiName", "execution-plans" ]
        ],
        "period": 300,
        "stat": "p95",
        "region": "eu-central-1",
        "title": "GET ApiGateway: Latency p95"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [ "AWS/ApiGateway", "Count", "ApiName", "execution-plans" ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "GET ApiGateway: Requests"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [ "AWS/ApiGateway", "5XXError", "ApiName", "execution-plans" ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "GET ApiGateway: 500 Errors"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [ "AWS/Lambda", "Invocations", "FunctionName", "get-execution-plan-eu-central-1" ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "GET lambda: invocations"
      }
    },
    {
      "type": "metric",
      "view": "timeSeries",
      "stacked": true,
      "properties": {
        "metrics": [
          [ "AWS/Lambda", "Errors", "FunctionName", "get-execution-plan-eu-central-1" ]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "eu-central-1",
        "title": "GET lambda: errors"
      }
    }
  ]
}
EOF
}
