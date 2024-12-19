provider "aws" {
   region     = "us-east-1"
}

resource "aws_instance" "ec2_example" {

   ami           =  var.ami_id
   instance_type =  var.instance_type
   key_name      =  "aws-demo"
   tags = {
           Name = "Terraform EC2"
   }
}

variable "instance_type" {
   description = "Instance type t2.micro"
   type        = string
   default     = "t2.micro"
}

variable "ami_id" {
   description = "The AMI ID to be used for the EC2 instance"
   type        = string
   default     = "ami-0e2c8caa4b6378d8c"
}

