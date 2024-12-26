variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to access EC2 instances"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_cird_block" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "environment" {
  description = "Environment type (e.g., Dev, Staging, Prod)"
  type        = string
 
}
variable "amis" {
  description = "Mapping of region to AMI IDs"
  type        = map(string)
  
}

variable "ingress_value" {
  description = "Ingress rules for security group"
  type = list(object({
    cidr_blocks = list(string)
    protocol    = string
    from_port   = number
    to_port     = number
  }))
}
variable "egress_value" {
  description = "Egress rules for security group"
  type = list(object({
    cidr_blocks = list(string)
    protocol    = string
    from_port   = number
    to_port     = number
  }))
}
