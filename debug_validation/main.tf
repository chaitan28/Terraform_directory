provider "aws" {
   region                   = "us-east-1"
}

resource "aws_instance" "ec2_example" {
   ami           = "ami-0e2c8caa4b6378d8c"
   key_name      =  "aws-us-east-1"
   instance_type = var.instance_type
   tags = {
           Name = "Terraform-EC2"
           ENV = "DEV"
   }
}


