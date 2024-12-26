aws_region        = "us-east-1"
vpc_cidr          = "172.18.0.0/16"
vpc_name          = "DevSecOps-Vpc"
key_name          = "aws-us-east-1"
azs               = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_cird_block = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24"]
environment       = "Dev"
ingress_value = [
  for port in [80, 8080, 443, 8443, 22, 3306, 1900, 1443] : {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = port
    to_port     = port
  }
]


egress_value = [
  {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"                         # you're allowing all protocols (TCP, UDP, ICMP, etc.) to be used for outgoing traffic.
    from_port   = 0
    to_port     = 0
  }
]

amis = {
  us-east-1    = "ami-0e2c8caa4b6378d8c"
  us-east-2    = "ami-0b4624933067d393a"
  ap-south-1   = "ami-0fd05997b4dff7aac"
  eu-central-1 = "ami-007c3072df8eb6584"
}