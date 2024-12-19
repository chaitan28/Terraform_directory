provider "aws" {
   region     = "ap-south-1"
}

resource "aws_instance" "ec2_example" {
   ami                          = "ami-0614680123427b75e"
   instance_type                =  "t2.micro"
   count                        = 1
   key_name                     = "aws-mumbai"
   vpc_security_group_ids       = [aws_security_group.example_sg.id]
   associate_public_ip_address  = var.enable_public_ip
   tags = {
           Name = "Terraform EC2"
   }

}

variable "enable_public_ip" {
  description = "Enable public IP address"
  type        = bool
  default     = true
}

resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Security group for EC2 instance"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP for better security
  }

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}


