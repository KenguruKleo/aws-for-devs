#!/bin/bash

aws s3 cp s3://kengurukleo-aws-for-dews/dynamodb-script.sh /home/ec2-user/dynamodb-script.sh
aws s3 cp s3://kengurukleo-aws-for-dews/rds-script.sql /home/ec2-user/rds-script.sql
sudo yum install -y java-1.8.0-openjdk
