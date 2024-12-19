provider "aws" {
   region     = "ap-south-1"
   
}

resource "aws_key_pair" "custom_aws_key" {
  key_name   = "custom_aws"
  public_key = file("C:/Users/user/Desktop/vscode/terraform/provisioners/file/custom_aws.pub")
}

resource "aws_instance" "ec2_example" {

    ami                           = "ami-053b12d3152c0cc71"  
    instance_type                 = "t2.micro" 
    key_name                      = aws_key_pair.custom_aws_key.key_name
    vpc_security_group_ids        = [aws_security_group.main.id]

   provisioner "file" {
    source      = "C:/Users/user/Desktop/vscode/terraform/provisioners/file/new.txt"
    destination = "/home/ubuntu/test-file.txt"
  }

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("C:/Users/user/Desktop/vscode/terraform/provisioners/file/custom_aws.pem")
      timeout     = "4m"
   }
   tags = {
     Name = "Terraform-EC2"
   }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}


