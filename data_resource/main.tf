provider "aws" {
  region                   = "ap-south-1"
}

resource "aws_instance" "ec2_example" {

   ami           = "ami-0fd05997b4dff7aac"
   instance_type =  "t2.micro"
   key_name      =  "aws-mumbai"
   tags = {
           Name = "Terraform EC2"
   }
}




data "aws_instance" "myawsinstance" {
    filter {
      name = "tag:Name"
      values = ["Terraform EC2"]
    }

    depends_on = [
      aws_instance.ec2_example
    ]
}

output "fetched_info_from_aws" {
  value = data.aws_instance.myawsinstance.public_ip
}

