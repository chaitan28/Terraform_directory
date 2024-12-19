provider "aws" {
   region     = "ap-south-1"
  
}
resource "aws_instance" "ec2_example" {

   ami           = "ami-0614680123427b75e"
   instance_type =  "t2.micro"
   count = 1

   tags = {
           Name = "Terraform EC2"
   }

}

resource "aws_iam_user" "example" {
  for_each = var.user_names
  name  = each.key
  tags = {
  Description = each.value
}
}

variable "user_names" {
  description = "IAM usernames"
  type        = map(string)
  default     = {

    user1  =  "normal user"
    user2  =  "admin user"
    user3  =  "root user"
  }
}
