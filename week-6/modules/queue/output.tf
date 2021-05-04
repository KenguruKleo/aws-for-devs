output "edu-lohika-training-aws-sqs-queue" {
  description = "The ARN of the SQS queue"
  value = aws_sqs_queue.edu-lohika-training-aws-sqs-queue
  
}

output "edu-lohika-training-aws-sns-topic" {
  description = "The ARN of the SNS queue"
  value = aws_sns_topic.edu-lohika-training-aws-sns-topic

}
