provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "ec2_example" {
  ami             = "ami-01816d07b1128cd2d"
  instance_type   =  "t2.micro"
  key_name        =  "aws-us-east-1"
  tags = {
    Name = "Terraform EC2 "
  }
}

resource "null_resource" "null_resource_with_remote_exec" {

# This trigger will only execute once when it detects the instance id of EC2 instance 

  triggers = {
    id = aws_instance.ec2_example.id   # to execute it every time replace - id = time().trigger will only work when it detects the change in the key-value pair
  }
  
  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote provisioner >> hello.txt",
    ]
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/user/Desktop/cloud_keys/aws-us-east-1.pem")
    timeout     = "4m"
    host        = aws_instance.ec2_example.public_ip
  }
}

output "instance_ip" {
  value = aws_instance.ec2_example.public_ip
}