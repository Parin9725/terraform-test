resource "aws_sqs_queue" "terraform_queue" {
  name                       = "terraform-example-queue"
  visibility_timeout_seconds = 600
}
