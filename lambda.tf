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

resource "aws_lambda_function" "test_lambda" {
  function_name = "${var.environment}-${var.project}"
  s3_bucket     = "parin-dataa"
  s3_key        = "lambda.zip"
  handler       = "main.handler"
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = "dotnetcore3.1"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
