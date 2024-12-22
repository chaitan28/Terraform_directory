variable "region" {
   description = "select the aws region "
   type        = string
}

variable "aws_profile" {
   description = "select the aws credentials"
   type        = string
}

variable "instance_type" {
   description = "select the aws Instance type "
   type        = string
}
variable "key_name" {
   description = "select the aws_key in specific region"
   type        = string
}