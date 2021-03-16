## Week 1

- Deploy stack: (no spaces in parameters Key and Value)
  ```
  aws cloudformation create-stack \
    --stack-name stack-week-1 \
    --template-body file://autoscale-group.yaml \
    --parameters ParameterKey=KeyName,ParameterValue=aws-lohika-key-pair
  ```
- Describe your stack: (find Output section with PublicIp and copy ip address e.g. `34.220.117.59`)
    ```
    aws cloudformation describe-stacks --stack-name stack-week-1
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
    aws cloudformation delete-stack --stack-name stack-week-1
    ```
