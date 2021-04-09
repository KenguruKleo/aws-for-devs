## Week 2

- Deploy stack: (no spaces in parameters Key and Value)
  ```
  aws cloudformation create-stack \
    --stack-name stack-week-2 \
    --template-body file://stack-with-access-s3.yaml \
    --parameters ParameterKey=KeyName,ParameterValue=aws-lohika-key-pair \
    --capabilities CAPABILITY_IAM >> logs.log
  ```
- Describe your stack: (find Output section with PublicIp and copy ip address e.g. `34.220.117.59`)
    ```
    aws cloudformation describe-stacks --stack-name stack-week-2 >> logs.log
    ```
- Connect by `ssh` using `aws-lihika-key-pair` key:
    ```
    ssh -i aws-lohika-key-pair.pem ec2-user@34.220.117.59
    ```
- Check Java version:
    ```
    java -version
    ```
- Delete stack:
    ```
    aws cloudformation delete-stack --stack-name stack-week-2 >> logs.log
    ```

### Terraform

```
terraform init
terraform apply -var 'instance_name=AnotherName03'
terraform destroy
```

Retrieve the public key for your key pair:
```
ssh-keygen -y -f /path_to_key_pair/my-key-pair.pem
```

Upload new kay pair
```
resource "aws_key_pair" "aws-lohika-key-pair" {
  key_name   = "aws-lohika-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCGmE9T3KQ0BGrym/CCoyiUKu4ytGxTuhh0XiYz1XrCJMYBE5mH/HSp4DYMtjqxjcBJUUcW8Da1xkSakQOxEFHFHEQvskAf9smv3PYSd0pqrUJ83RY58gmiu4hUMtt8ICsLRegw3XGcpo4zpS7a6YcAkvqhA787M7rNvMhAK9KvfAW9EBDtNXNLmumIqklDO/6m0HXrAsgxAS3lwOmvIsmGK9g/pyjW86ZQVSx0GOGcI9jrIxFAwYoHXoSgl4WYj2MHOFoRdGLFi1osVolN1V4FKJVfCdi51LJ4Sa2w/RYqNJPwNVu+aUj8PA8D5wXMw4CC96pGSDHmadzeyP3cFz0z"
}
```

### Exaple:
```
Fn::Base64:
  Fn::Join:
  - "\n"
  - - "#!/bin/bash"
    - yum update -y
    - yum install -y httpd24 php56
    - service httpd start
    - chkconfig httpd on
    - groupadd DMO
    - usermod -a -G DMO ec2-user
    - chgrp -R DMO /var/www
    - chmod 2775 /var/www
    - aws s3 cp s3://MYBUCKET/MYFILE.zip /tmp
    - unzip -d /var/www /tmp/MYFILE.zip
    - rm /tmp/MYFILE.zip
    - find /var/www -type d -exec chmod 2775 {} +
    - find /var/www -type f -exec chmod 0664 {} +
```