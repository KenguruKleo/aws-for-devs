## Week 5

### Terraform
```
terraform init
terraform apply -var 'instance_name=AnotherName05'
terraform destroy
```

### Send message
```
aws sqs send-message --queue-url https://sqs.us-west-2.amazonaws.com/214066540222/terraform-example-queue --message-body "Information about the largest city in Any Region." --region us-west-2
```

### Receive message
```
aws sqs receive-message --queue-url https://sqs.us-west-2.amazonaws.com/214066540222/terraform-example-queue
```

### Send notification
```
aws sns publish --topic-arn "arn:aws:sns:us-west-2:214066540222:user-updates-topic" --message "hello world 123" --region us-west-2
```