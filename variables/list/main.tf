provider "aws" {
   region     = "ap-south-1"
   
}
resource "aws_instance" "ec2_example" {

   ami            = "ami-0614680123427b75e"
   instance_type  =  "t2.micro"
   count          =    1
   key_name       =  "aws-mumbai"
   tags = {
           Name = "Terraform EC2"
   }

}
# Resource Block
resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

# Variable Definition
variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["user1", "user2", "user3"]
}

