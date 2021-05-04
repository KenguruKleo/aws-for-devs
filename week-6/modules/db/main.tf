
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "11.10"
  instance_class       = "db.t3.micro"
  name                 = "EduLohikaTrainingAwsRds"
  username             = "rootuser"
  password             = "rootuser"
  port                 = 5432
  skip_final_snapshot  = true
  deletion_protection  = false
}

resource "aws_dynamodb_table" "edu-lohika-training-aws-dynamodb" {
  name           = "edu-lohika-training-aws-dynamodb"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserName"

  attribute {
    name = "UserName"
    type = "S"
  }
}
