terraform {
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "5.50.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}


terraform {
  backend "s3" {
    bucket = "terraform-19122024"
    key    = "remote-dev/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}
#  Create a VPC
resource "aws_vpc" "zemi_dev" {
  cidr_block            = "10.1.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags = {
    Name = "vpc-zemi"
  }
}

# Create an Internet Gateway (IGW) and Attach it to the VPC
resource "aws_internet_gateway" "zemi_igw" {
  vpc_id = aws_vpc.zemi_dev.id

  tags = {
    Name = "igw-zemi"
  }
}

#  Create Public Subnet
resource "aws_subnet" "zemi_public_subnet" {
  vpc_id                  = aws_vpc.zemi_dev.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true  # So EC2 instances in this subnet get a public IP
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "public-subnet-zemi"
  }
}


# Create a Route Table for Public Subnet
resource "aws_route_table" "zemi_public_rt" {
  vpc_id = aws_vpc.zemi_dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zemi_igw.id
  }

  tags = {
    Name = "public-rt-zemi"
  }
}

#  Associate Public Subnet with Route Table
resource "aws_route_table_association" "zemi_public_rta" {
  subnet_id      = aws_subnet.zemi_public_subnet.id
  route_table_id = aws_route_table.zemi_public_rt.id
}

##=================
# create a EC2 ##
#==================
resource "aws_instance" "Dev-zemi" {
    ami                          = "ami-0fd05997b4dff7aac"
    instance_type                =  "t2.micro"
    key_name                     = "aws-mumbai"
    subnet_id                    = aws_subnet.zemi_public_subnet.id
    associate_public_ip_address  = true
    vpc_security_group_ids       = [aws_security_group.zemi-sg.id]
    tags = {
        Name       = "zemieccom"
        Enrinoment = "DEV"
        value      = "v13"
    }
}

####===========================
### create a security group ####
### ==========================
resource "aws_security_group" "zemi-sg" {
    name   = "Dev-sg"
    vpc_id = aws_vpc.zemi_dev.id
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