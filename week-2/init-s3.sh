#!/bin/bash

BUCKET_NAME=kengurukleo-aws-for-dews

echo "Test file for S3" >> test-s3.txt
{
    aws s3api create-bucket --bucket $BUCKET_NAME --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
    aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
    aws s3 cp test-s3.txt s3://$BUCKET_NAME/
} >> logs.log
rm test-s3.txt
