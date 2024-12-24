provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
  ami             = "ami-0e2c8caa4b6378d8c"
  instance_type   = "t2.medium"
  key_name        = "aws-us-east-1"
  tags = {
     Name = "POC_JENKINS"
  }
}