provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test" {
  ami                     = "ami-0453ec754f44f9a4a"
  instance_type           = "t2.micro"
  key_name                = "aws-demo"
  tags = {
    Name = "poc_ec2"
    ENV= "Dev"
  }

}