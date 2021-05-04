resource "aws_iam_role" "MyAppServerRole" {
  name = "MyAppServerRole"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "InstancePolicy" {
  name = "InstancePolicy"
  role = aws_iam_role.MyAppServerRole.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:CreateBucket",
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        "Resource": "arn:aws:dynamodb:*:*:table/aws_course_table_01"
      },
      {
        "Effect": "Allow",
        "Action": [
          "sqs:*"
        ],
        "Resource": "${var.edu-lohika-training-aws-sqs-queue.arn}"
      },
      {
        "Effect": "Allow",
        "Action": [
          "sns:*"
        ],
        "Resource": "${var.edu-lohika-training-aws-sns-topic.arn}"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "RootInstanceProfile" {
  name = "RootInstanceProfile"
  role = aws_iam_role.MyAppServerRole.name
}
