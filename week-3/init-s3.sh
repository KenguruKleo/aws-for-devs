#!/bin/bash

BUCKET_NAME=kengurukleo-aws-for-dews

{
    aws s3api create-bucket --bucket $BUCKET_NAME --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
    aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
    aws s3 cp dynamodb-script.sh s3://$BUCKET_NAME/
    aws s3 cp rds-script.sql s3://$BUCKET_NAME/
} >> logs.log
