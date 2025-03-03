provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test" {
  ami             = "ami-04b4f1a9cf54c11d0"
  instance_type   = "t2.medium"
  key_name        = "aws-us-east-1"
  security_groups = [aws_security_group.test_sg.name]  # Attach SG to the instance
  iam_instance_profile = aws_iam_instance_profile.admin_profile.name
  tags = {
    Name = "Eks-admin"
    ENV  = "EKS"
  }
}

resource "aws_security_group" "test_sg" {
  name        = "poc_ec2_sg"
  description = "Allow inbound and outbound traffic"
  vpc_id      = "vpc-01e40f303fba60b00"  # Replace with your VPC ID

  # Inbound Rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (change for security)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS access
  }

  # Outbound Rules (Allow all traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "poc_ec2_sg"
    ENV  = "Dev"
  }
}

terraform {
  backend "s3" {
    bucket         = "s3-whytebatl-global"    # Replace with your S3 bucket name
    key            = "terraform/eks.tfstate" # State file path inside S3
    region         = "us-east-1"
    encrypt        = true                    # Encrypt state file
    dynamodb_table = "terraform-lock"        # Enable state locking
  }
}
# 🔹 IAM Role for EC2 with Admin Access
resource "aws_iam_role" "admin_role" {
  name = "ec2-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# 🔹 Attach AdministratorAccess Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 🔹 IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "admin_profile" {
  name = "ec2-admin-profile"
  role = aws_iam_role.admin_role.name
}
