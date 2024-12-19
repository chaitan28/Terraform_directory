provider "aws" {
   region     = "ap-south-1"
  
}
#resource block
resource "aws_instance" "ec2_example" {

   ami           = "ami-0614680123427b75e"
   instance_type =  "t2.micro"

   tags = var.project_environment

}

# variable block
variable "project_environment" {
  description = "project name and environment"
  type        = map(string)
  default     = {
    Name        = "EC2-AWS"         # key: value pair
    project     = "project-alpha",  # key: value pair 
    environment = "dev"             # key: value pair
  }
}


output "instance_ip" {
   value = aws_instance.ec2_example.public_ip
}

