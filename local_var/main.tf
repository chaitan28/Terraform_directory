provider "aws" {
   region     = "ap-south-1"
}

locals {
  staging_env = "staging"
}

resource "aws_vpc" "staging-vpc" {
  cidr_block = "10.5.0.0/16"

  tags = {
    Name = "${local.staging_env}-vpc-tag"
  }
}

resource "aws_internet_gateway" "staging_igw" {
  vpc_id = aws_vpc.staging-vpc.id

  tags = {
    Name = "${local.staging_env}-igw-tag"
  }
}

resource "aws_subnet" "staging-subnet" {
  vpc_id                  = aws_vpc.staging-vpc.id
  cidr_block              = "10.5.0.0/20"
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.staging_env}-subnet-tag"
  }
}

resource "aws_route_table" "staging_rt" {
  vpc_id = aws_vpc.staging-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.staging_igw.id
  }

  tags = {
    Name = "${local.staging_env}-rt-tag"
  }
}

resource "aws_route_table_association" "staging_rta" {
  subnet_id      = aws_subnet.staging-subnet.id
  route_table_id = aws_route_table.staging_rt.id
}

resource "aws_instance" "ec2_example" {
   ami                 = "ami-053b12d3152c0cc71"
   instance_type       = "c5.large"
   subnet_id           =  aws_subnet.staging-subnet.id
   key_name            =  "aws-mumbai"
   security_groups     = [ aws_security_group.staging_sg.id ]
   tags = {
           Name = "${local.staging_env} - Terraform EC2"
   }
}

resource "aws_security_group" "staging_sg" {
  name        = "web-server-sg"
  description = "Security Group for web server"
  vpc_id      = aws_vpc.staging-vpc.id

  # Inbound Rules
  ingress {
    description      = "Allow SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Outbound Rules
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"  # -1 means all protocols
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  description = "The public IP of the instance."
  value       =  aws_instance.ec2_example.public_ip
} 

output "security_group_id" {
  description = "The ID of the security group."
  value       =  aws_security_group.staging_sg.id
}
