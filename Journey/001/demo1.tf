provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
  alias = "useast2"
}

resource "aws_instance" "us-east-1" {
  ami           = "ami-09d3b3274b6c5d4aa" # us-east-1
  instance_type = "t2.micro"
}

resource "aws_instance" "us-east-2" {
  ami           = "ami-089a545a9ed9893b6" # us-east-2
  instance_type = "t2.micro"
  provider=aws.useast2
  
}

resource "aws_s3_bucket" "myfirstbucket" {
  bucket = "s3-ec2-terraform-bucket"
  acl ="private"

  tags = {
    Name        = "My terraform bucket"
    Environment = "Dev-Env"
  }
  versioning{
  	enabled=true
  }
}

resource "aws_vpc" "dev" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "sub" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "dev-subnet"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  db_name              = "myterraformdb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}


