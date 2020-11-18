resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "Lambda_Basic_execution"
  description = "A test policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
		"logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:897701442878:log-group:/aws/lambda/parin/*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:*:897701442878:*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "sqs:DeleteMessage",
                "sqs:ReceiveMessage",
                "sqs:GetQueueAttributes"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_function" "test_lambda" {
  function_name = "parin"
  s3_bucket     = "parin-dataa"
  s3_key        = "lambda.zip"
  handler       = "main.handler"
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = "dotnetcore3.1"
  timeout       = 600
  memory_size   = 128
  depends_on = [
    aws_iam_role_policy_attachment.test-attach,
    aws_cloudwatch_log_group.example,
  ]

}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/parin-logs"
  retention_in_days = 7
}


resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = "${aws_sqs_queue.terraform_queue.arn}"
  enabled          = true
  function_name    = "${aws_lambda_function.test_lambda.arn}"
  batch_size       = 1
}
