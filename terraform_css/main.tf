#
# VPC:
#
resource "aws_vpc" "css_vpc" {
  cidr_block           = var.css_vpc_cidr
  enable_dns_hostnames = true
  tags = {
      Name = join("-", [ var.env_prefix, "vpc" ])
  }
}

#
# Subnets:
#
resource "aws_subnet" "css_subnet_zone_a" {
  vpc_id                           = aws_vpc.css_vpc.id
  cidr_block                       = cidrsubnet(aws_vpc.css_vpc.cidr_block, 8, 1)
  availability_zone                = join("",[var.aws_region,"a"]) # Will be: us-east-1a
  map_public_ip_on_launch          = true
  tags = {
      Name = join("-", [ var.env_prefix, "us-east-1a-subnet" ])
  }
}

resource "aws_subnet" "css_subnet_zone_b" {
  vpc_id                           = aws_vpc.css_vpc.id
  cidr_block                       = cidrsubnet(aws_vpc.css_vpc.cidr_block, 8, 2)
  availability_zone                = join("",[var.aws_region,"b"]) # Will be: us-east-1b
  map_public_ip_on_launch          = true
  tags = {
      Name = join("-", [ var.env_prefix, "us-east-1b-subnet" ])
  }
}

#
# IGW for the public subnet:
#
resource "aws_internet_gateway" "css_internet_gateway" {
  vpc_id = aws_vpc.css_vpc.id
  tags = {
      Name = join("-", [ var.env_prefix, "igw" ])
  }
}

#
# Route table:
#
resource "aws_route_table" "css_route_table" {
  vpc_id = aws_vpc.css_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.css_internet_gateway.id
  }
  tags = {
    Name = join("-", [ var.env_prefix, "rt" ])
  }
}

#
# Route table associations:
#
resource "aws_route_table_association" "css_route_table_association_subnet_a" {
  subnet_id      = aws_subnet.css_subnet_zone_a.id
  route_table_id = aws_route_table.css_route_table.id
}

resource "aws_route_table_association" "css_route_table_association_subnet_b" {
  subnet_id      = aws_subnet.css_subnet_zone_b.id
  route_table_id = aws_route_table.css_route_table.id
}

#
# Security Group:
#
resource "aws_security_group" "css_security_group" {
  name = join("-", [ var.env_prefix, "sg" ])
  #name = "hawkbit-prod-SecurityGroupHawkBit-12ZLUKYXDOKS0"
  vpc_id      = aws_vpc.css_vpc.id
  ingress {
    description = "Public access"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Public access"
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = join("-", [ var.env_prefix, "sg" ])
  }
}