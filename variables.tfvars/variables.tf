variable "instance_type" {
   type = string
   description = "EC2 Instance Type"
}


variable "ami_id" {
    type = string
    description = "Choose centos or ubuntu ami "
}

variable "aws_region" {
    type = string
    description = "Choose aws region"
}

variable "aws_keys" {
   type =  string
   description = "The tag for the EC2 instance"
}



variable "tags" {
   type = map(string)
   description = "The tag for the EC2 instance"
}

