provider "aws" {
   region     = "us-east-1"
   
}

resource "aws_instance" "ec2_example" {

   ami           = "ami-0e2c8caa4b6378d8c"
   instance_type =  "t2.micro"
   count         =  var.instance_count
   tags          =     {
     Name = "Terraform-EC2-${count.index + 1}"
   }
}

variable "instance_count" {
  description = "EC2 instance count"
  type        = number
  default     = 2
}

