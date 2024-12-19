 provider "aws" {
   region     = "us-east-2"  
}

locals {
  instance_name = "${terraform.workspace}-instance" 
}

resource "aws_instance" "ec2_example" {

    ami           = "ami-0b4624933067d393a" 
    instance_type = var.instance_type
    key_name      = "aws-us-east-2"
    tags = {
      Name = local.instance_name
    }
}
