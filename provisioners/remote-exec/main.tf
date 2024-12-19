provider "aws" {
  region = "ap-south-1"
}

# Create AWS Key Pair 
resource "aws_key_pair" "custom_aws_key" {
  key_name   = "custom_aws"
  public_key = file("C:/Users/user/Desktop/vscode/terraform/provisioners/file/custom_aws.pub")
}

# Security Group with SSH and HTTP access
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
 ingress                = [                     # You can only have one ingress block in the resource, but you have two.
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = "Allow SSH access"
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false        # The self parameter defines whether traffic from the same security group (other instances with this security group attached) is allowed to communicate with each other.               
     to_port          = 22
   },
  
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = "Allow HTTP access"
     from_port        = 80
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false         # The self parameter defines whether traffic from the same security group (other instances with this security group attached) is allowed to communicate with each other.
     to_port          = 80
  }
  ]
}

# Launch EC2 instance with Nginx
resource "aws_instance" "ec2_example" {
  ami                           = "ami-0fd05997b4dff7aac"  
  instance_type                 = "t2.micro" 
  key_name                      = aws_key_pair.custom_aws_key.key_name
  vpc_security_group_ids        = [aws_security_group.main.id]

  user_data = <<-EOF
#!/bin/bash
# Install Nginx and Git
sudo yum update -y
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx git

# Start Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx

# Install Firewall and configure HTTP port
sudo yum install -y firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload

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

  provisioner "remote-exec" {
    inline = [
      "touch /home/ec2-user/hello.txt",
      "echo 'helloworld! welcome' >> /home/ec2-user/hello.txt",
    ]
  }

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
