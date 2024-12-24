provider "aws" {
  region = "us-east-1"
}

# Define the S3 bucket
resource "aws_s3_bucket" "test_bucket" {
  bucket = "terraform-24122024"           # Make sure this bucket name is globally unique
  
  tags = {
    ENV = "DEV"
  }
}

resource "aws_s3_bucket_acl" "example" {
bucket = aws_s3_bucket.test_bucket.id
}




