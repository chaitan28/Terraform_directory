provider "aws" {
   region     = "ap-south-1"   
}

resource "aws_instance" "ec2_example" {

    ami            = "ami-053b12d3152c0cc71"  
    instance_type  = "t2.micro" 
    tags = {
        Name = "Terraform EC2"
    }

  provisioner "local-exec" {
    command = "echo hi > file.txt"
  }
}
