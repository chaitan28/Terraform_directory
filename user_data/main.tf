#main.tf 

provider "aws" {
  region     = "us-east-2"
}


resource "aws_instance" "example" {
  ami                     = "ami-036841078a4b68e14"
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.main.id]
  key_name                = "aws-us-east-2"
  user_data               =  "${file("install_apache.sh")}"
  tags = {
    Name = "Terraform-EC2"
  }
}

resource "aws_security_group" "main" {
    name   = "Dev-sg"
ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]         # Allow SSH only from anywhere
  }

ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]           # Allow HTTP from anywhere
  }
    egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"                    # -1 means all protocols
    cidr_blocks      = ["0.0.0.0/0"]           # Allow outbound to anywhere
  }
}