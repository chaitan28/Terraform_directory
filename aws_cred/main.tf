provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

resource "aws_instance" "test" {
  ami                     = "ami-0453ec754f44f9a4a"
  instance_type           =  var.instance_type.id
  key_name                =  var.key_name.id
  tags = {
    Name = "poc_ec2"
    ENV= "Dev"
  }
}