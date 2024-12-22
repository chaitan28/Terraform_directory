
variable "instance_type" {
   description = "Instance type t2.micro"
   type        = string

 validation {
 condition     = can(regex("^[Tt][2-3].(nano|micro|small)", var.instance_type))
 error_message = "Invalid Instance Type name. You can only choose - t2.nano,t2.micro,t2.small"
}
}