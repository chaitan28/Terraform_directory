
resource "aws_instance" "ec2_example" {
   ami            =  var.ami_id
   instance_type  =  var.instance_type
   tags           =  var.tags
   key_name       =  var.aws_keys
 
   
} 
