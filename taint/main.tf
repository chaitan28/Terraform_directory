provider "aws" {
  region = var.aws_region

}

# if user-date section is added in the instance resource , everytime change in the file .
# terraform will destroy and create the instance which will have impact of the user experience.so to tackle this issue we have created a separate null_resource

resource "aws_instance" "public-server" {
  count                       = var.environment == "Prod" ? 3 : 1 # Create 3 instances if environment is Prod, else create 1 instance
  ami                         = lookup(var.amis, var.aws_region)  #lookup(var.amis, var.region) var.region = "us-east-1", Terraform selects "us-east-1 = ami-1231" otherwise different
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = element(aws_subnet.public-subnet.*.id, count.index) # count = length of string
  vpc_security_group_ids      = [aws_security_group.allow_all.id]                   # Assuming allow_all security group is defined
  associate_public_ip_address = true
  tags = {
    Name        = "${var.vpc_name}-Public-Server-${count.index + 1}" # Unique Name per instance
    Owner       = local.Owner
    costcenter  = local.costcenter
    TeamDL      = local.TeamDL
    environment = var.environment
  }
}





