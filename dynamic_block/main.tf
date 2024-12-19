provider "aws" {
  region = "ap-south-1"
}

# Create AWS Key Pair 
resource "aws_key_pair" "custom_aws_key" {
  key_name   = "custom_aws"
  public_key = file("C:/Users/user/Desktop/vscode/terraform/provisioners/file/custom_aws.pub")
}

locals {
   ingress_rules = [{
      port        = 443
      description = "Ingress rules for port 443"
   },
   {
      port        = 22
      description = "Ingress rules for port 443"
   },
   {
      port        = 80
      description = "Ingree rules for port 80"
   }]
}

resource "aws_security_group" "main" {
   name   = "resource_with_dynamic_block"


   dynamic "ingress" {
      for_each = local.ingress_rules

      content {
         description = ingress.value.description
         from_port   = ingress.value.port
         to_port     = ingress.value.port
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
      }
   }
}
# Launch EC2 instance with Nginx
resource "aws_instance" "ec2_example" {
  ami                           = "ami-0aa8fc2422063977a"  
  instance_type                 = "t2.micro" 
  key_name                      = aws_key_pair.custom_aws_key.key_name
  vpc_security_group_ids        = [aws_security_group.main.id]

  user_data = <<-EOF
#!/bin/bash
# Install Nginx and Git
sudo yum update -y
sudo yum install -y nginx git

# Start Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx



# Get Instance Metadata
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600") 
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/instance-id") 
AVAILABILITY_ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/placement/availability-zone") 
PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/public-ipv4") 

# Create HTML file to display instance details
cat <<EOL > /usr/share/nginx/html/index.html
<h1>Instance Details</h1>
<p><b>Instance ID:</b> $INSTANCE_ID</p>
<p><b>Availability Zone:</b> $AVAILABILITY_ZONE</p>
<p><b>Public IP:</b> $PUBLIC_IP</p>
EOL

# Restart Nginx after updating index.html
sudo systemctl restart nginx

# Install stress-ng for load testing
sudo yum install epel-release -y
sudo yum install stress-ng -y
  EOF

 

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("C:/Users/user/Desktop/vscode/terraform/provisioners/file/custom_aws.pem")
    timeout     = "4m"
  }

  tags = {
    Name = "Terraform-EC2"
  }
}
