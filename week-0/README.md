## Week 0

-  Create `aws-lohika-key-pair` key:
    ```
    aws ec2 create-key-pair --key-name aws-lohika-key-pair --query "KeyMaterial" --output text > aws-lohika-key-pair.pem
    ```
- Describe key (optional):
    ```
    aws ec2 describe-key-pairs --key-name aws-lohika-key-pair
    ```
- Update key permissions:
    ```
    chmod 400 aws-lohika-key-pair.pem
    ```
- Deploy stack: (no spaces in parameters Key and Value)
  ```
  aws cloudformation create-stack \
    --stack-name stack-week-0 \
    --template-body file://stack-with-1-ec2-instance.yaml \
    --parameters ParameterKey=KeyName,ParameterValue=aws-lohika-key-pair
  ```
- Get list of stacks:
    ```
    aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE
    ```
- Describe your stack: (find Output section with PublicIp and copy ip address e.g. `34.220.117.59`)
    ```
    aws cloudformation describe-stacks --stack-name stack-week-0
    ```
- Connect by `ssh` using `aws-lihika-key-pair` key:
    ```
    ssh -i aws-lohika-key-pair.pem ec2-user@34.220.117.59
    ```
- Delete stack:
    ```
    aws cloudformation delete-stack --stack-name stack-week-0
    ```
