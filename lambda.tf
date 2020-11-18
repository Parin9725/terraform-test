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
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
             ],
             "Resource": "arn:aws:logs:*:*:*",
             "Effect": "Allow"
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
  s3_bucket     = "jfyjvgjyt"
  s3_key        = "lambda.zip"
  handler       = "main.handler"
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = "dotnetcore3.1"
  timeout       = 600
  memory_size   = 128
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = "${aws_sqs_queue.terraform_queue.arn}"
  enabled          = true
  function_name    = "${aws_lambda_function.test_lambda.arn}"
  batch_size       = 1
}

