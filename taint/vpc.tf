resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "public-subnet" {
  count = length(var.azs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_cird_block, count.index)  # count = length of string
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-Public-Subnet-${count.index + 1}"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow specific inbound and all outbound rules"
  vpc_id      = aws_vpc.main.id
dynamic "ingress" {
    for_each = var.ingress_value
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = var.egress_value[0].from_port
    to_port     = var.egress_value[0].to_port
    protocol    = var.egress_value[0].protocol
    cidr_blocks = var.egress_value[0].cidr_blocks
  }
}


resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw-public"
  }
}

# Create a Route Table for Public Subnet
resource "aws_route_table" "test_public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

#  Associate Public Subnet with Route Table
resource "aws_route_table_association" "test_public_rta" {
  count           = length(aws_subnet.public-subnet)
  subnet_id       = element(aws_subnet.public-subnet.*.id, count.index)     
  route_table_id  = aws_route_table.test_public_rt.id
}