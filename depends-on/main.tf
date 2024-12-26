provider "aws" {
    region = "us-east-1"
  
}

# Step 1 - Create an S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "terraform-26122024"
}

# Generate a secure random password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?" # Define special characters allowed, if needed
}

# Step 2 - Create an AWS DB Instance
resource "aws_db_instance" "example" {
  instance_class            = "db.t3.micro"
  allocated_storage         = 64
  engine                    = "mysql"
  username                  = "admin"
  password                  = random_password.password.result
  publicly_accessible       = "true"
  skip_final_snapshot       =  true # Ensure a final snapshot is created. If you set skip_final_snapshot = true, no snapshot is taken, and final_snapshot_identifier is not needed.
  # final_snapshot_identifier  = "exampledb-final-snapshot-1"
}
#Terraform tells that the instance resource depends on both the S3 bucket and the RDS database, so it should be created or modified only after both resources have been created or modified.

# Step 3 - Create an EC2 Instance with dependency on S3 Bucket, DB Instance
resource "aws_instance" "example_instance" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  key_name      = "aws-us-east-1"
  depends_on = [aws_s3_bucket.example_bucket, aws_db_instance.example]  # It's important to note that the order of resource references in the "depends_on" argument does not matter. Terraform will automatically determine the correct order in which to create or modify the resources based on the dependencies specified.
  tags = {
   Name = "Terraform-EC2"
}
}

# Output the generated password (optional)
output "db_password" {
  value       = random_password.password.result
   sensitive   = true # Mark it sensitive to prevent accidental exposure
}
