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
  filename      = "lambda_function_payload.zip"
  function_name = "parin"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "exports.test"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  runtime = "dotnetcore3.1"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
