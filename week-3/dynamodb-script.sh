#!/bin/bash

aws dynamodb list-tables --region us-west-2

echo "put (key -> '1' value -> 'Konst')"
aws dynamodb put-item --table-name "aws_course_table_01" --item '{ "LookupKey": {"N": "1"}, "Value": {"S": "Konst"} }' --region us-west-2

echo "put (key -> '2' value -> 'Serg')"
aws dynamodb put-item --table-name "aws_course_table_01" --item '{ "LookupKey": {"N": "2"}, "Value": {"S": "Serg"} }' --region us-west-2

echo "get value with key 1"
aws dynamodb get-item --table-name "aws_course_table_01" --key '{ "LookupKey": {"N": "1"} }' --region us-west-2

echo "get value with key 2"
aws dynamodb get-item --table-name "aws_course_table_01" --key '{ "LookupKey": {"N": "2"} }' --region us-west-2

echo "get unexisting value"
aws dynamodb get-item --table-name "aws_course_table_01" --key '{ "LookupKey": {"N": "3"} }' --region us-west-2
