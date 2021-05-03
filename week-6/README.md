## Week 6

### Terraform
```
terraform init
terraform apply -var 'instance_name=AnotherName03'
terraform destroy
```

### Copy key

scp -i ~/.ssh/aws-lohika-key-pair.pem ~/.ssh/aws-lohika-key-pair.pem ec2-user@54.201.148.178:aws-lohika-key-pair.pem

ssh -i aws-lohika-key-pair.pem ec2-user@private-ip