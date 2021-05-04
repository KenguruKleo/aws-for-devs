resource "aws_sqs_queue" "edu-lohika-training-aws-sqs-queue" {
  name = "edu-lohika-training-aws-sqs-queue"
}

resource "aws_sns_topic" "edu-lohika-training-aws-sns-topic" {
  name = "edu-lohika-training-aws-sns-topic"
}
