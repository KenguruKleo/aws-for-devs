resource "aws_instance" "PublicInstance" {
  ami           = "ami-00f9f4069d04c0c6e"
  instance_type = "t2.micro"
  key_name      = var.key_name
  count         = 2
  subnet_id     = var.public_subnets_id

  iam_instance_profile = var.profile

  vpc_security_group_ids = [
      aws_security_group.allow_ssh.id,
      aws_security_group.allow_http.id,
      aws_security_group.allow_PostgreSQL.id,
      aws_security_group.allow_all_outbound.id
  ]

  user_data     = <<-EOT
    #cloud-config
    runcmd:
    - sudo yum install -y java-1.8.0-openjdk
    - aws s3 cp s3://kengurukleo-aws-for-dews/calc-2021-0.0.2-SNAPSHOT.jar /home/ec2-user/calc-2021-0.0.2-SNAPSHOT.jar
    - java -jar /home/ec2-user/calc-2021-0.0.2-SNAPSHOT.jar
  EOT

  tags = {
    Name = "public"
  }
}

resource "aws_instance" "PrivateInstance" {
  ami           = "ami-00f9f4069d04c0c6e"
  instance_type = "t2.micro"
  key_name      = var.key_name
  count         = 1
  subnet_id     = var.private_subnets_id

  iam_instance_profile = var.profile

  vpc_security_group_ids = [
      aws_security_group.allow_ssh.id,
      aws_security_group.allow_http.id,
      aws_security_group.allow_PostgreSQL.id,
      aws_security_group.allow_all_outbound.id
  ]

  user_data     = <<-EOT
    #cloud-config
    runcmd:
    - sudo yum install -y java-1.8.0-openjdk
    - aws s3 cp s3://kengurukleo-aws-for-dews/persist3-2021-0.0.1-SNAPSHOT.jar /home/ec2-user/persist3-2021-0.0.1-SNAPSHOT.jar
    - export RDS_HOST = ${var.rds_host}
    - java -jar /home/ec2-user/persist3-2021-0.0.1-SNAPSHOT.jar
  EOT

  tags = {
    Name = "private"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

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
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "allow_PostgreSQL" {
  name        = "allow_PostgreSQL"
  description = "Allow PostgreSQL inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_all_outbound" {
  name        = "allow_all_outbound"
  description = "Allow All outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    description = "All outbound from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
