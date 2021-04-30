terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleInstance"
}

resource "aws_instance" "Ec2Instance" {
  ami           = "ami-00f9f4069d04c0c6e"
  instance_type = "t2.micro"
  key_name         = "aws-lohika-key-pair"
  associate_public_ip_address = true

  count = 1
  
  iam_instance_profile = aws_iam_instance_profile.RootInstanceProfile.name

  vpc_security_group_ids = [
      aws_security_group.allow_ssh.id,
      aws_security_group.allow_http.id,
      aws_security_group.allow_all_outbound.id
  ]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_all_outbound" {
  name        = "allow_all_outbound"
  description = "Allow All outbound traffic"

  egress {
    description = "All outbound from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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
      }
    ]
  })
}

resource "aws_iam_instance_profile" "RootInstanceProfile" {
  name = "RootInstanceProfile"
  role = aws_iam_role.MyAppServerRole.name
}

resource "aws_sqs_queue" "terraform_queue" {
  name                        = "terraform-example-queue"
}

resource "aws_sns_topic" "user_updates" {
  name                        = "user-updates-topic"
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value = {
    for instance in aws_instance.Ec2Instance:
      instance.id => instance.public_ip
  }
}

output "sqs_queue_arn" {
  description = "The ARN of the SQS queue"
  value = aws_sqs_queue.terraform_queue.arn
}

output "sqs_queue_URL" {
  description = "The URL of the SQS queue"
  value = aws_sqs_queue.terraform_queue.id
}

output "sns_queue_arn" {
  description = "The ARN of the SNS queue"
  value = aws_sns_topic.user_updates.arn
}
