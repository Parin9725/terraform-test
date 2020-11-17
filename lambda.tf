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
  function_name = "parin"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "exports.test"

  runtime = "dotnetcore3.1"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
