provider "aws" {
  alias  = "us-east-1"  # Alias to distinguish this provider configuration for the us-east-1 region
  region = "us-east-1"  # AWS region for this provider
}

provider "aws" {
  alias  = "us-east-2"  # Alias to distinguish this provider configuration for the us-east-2 region
  region = "us-east-2"  # AWS region for this provider
}

resource "aws_instance" "example" {
  ami           = "ami-0166fe664262f664c"  # The Amazon Machine Image (AMI) used to launch the instance
  instance_type = "t2.micro"              # The EC2 instance type
  provider      = aws.us-east-1          # Specifies the provider to use for this resource (us-east-1 region)

  tags = {
    Name        =  "instance1-us-east-1"  # Name tag to identify the instance
    Environment =  "Development"               # Environment tag to indicate the environment this instance belongs to
    Owner       =  "Chaitanya"                   # Tag to specify the owner of this resource
  }
}

resource "aws_instance" "example2" {
  ami           = "ami-036841078a4b68e14"      # The Amazon Machine Image (AMI) used to launch the instance
  instance_type =  "t2.micro"                     # The EC2 instance type
  provider      =  aws.us-east-2               # Specifies the provider to use for this resource (us-east-2 region)

  tags = {
    Name        = "instance2-us-east-2"           # Name tag to identify the instance
    Environment = "QA"                             # Environment tag to indicate the environment this instance belongs to
    Owner       = "Chaitanya"                     # Tag to specify the owner of this resource
  }
} 

resource "aws_ec2_instance_state" "example" {
  instance_id = aws_instance.example.id                 # Reference to the ID of the EC2 instance from the "example" resource
  state       = "stopped"                                # Desired state for the EC2 instance (e.g., stopped, running)
}

resource "aws_ec2_instance_state" "example2" {
  instance_id = aws_instance.example2.id                        # Reference to the ID of the EC2 instance from the "example2" resource
  state       = "stopped"                                        # Desired state for the EC2 instance (e.g., stopped, running)
}
