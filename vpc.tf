# This file contains the VPC configuration for the patty moore project.
resource "aws_vpc" "yemi_logready_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "yemi-logready-vpc"
  }
}

# This resource creates an Internet Gateway and attaches it to the VPC.
# Internet Gateway for public subnets
resource "aws_internet_gateway" "yemi_logready_igw" {
  vpc_id = aws_vpc.yemi_logready_vpc.id

  tags = {
    Name = "yemi-logready-igw"
  }
}

# This resource creates a public subnet AZ 1a in the VPC.
# Ensure you name the subnet to public_subnet-az1a to match the naming convention.
resource "aws_subnet" "yemi-logready_public_az1a" {
  vpc_id                  = aws_vpc.yemi_logready_vpc.id
  cidr_block              = var.public_subnet_az1a_cidr
  availability_zone       = "us-east-1a" # Change this to your desired availability zone
  map_public_ip_on_launch = true

  depends_on = [aws_vpc.yemi_logready_vpc,
  aws_internet_gateway.yemi_logready_igw]

  tags = {
    Name = "yemi-logready-public-az1a"
  }
}

# This resource creates a public subnet AZ 1b in the VPC.
# Ensure you name the subnet to public_subnet-az1b to match the naming convention.
resource "aws_subnet" "yemi-logready_public_az1b" {
  vpc_id                  = aws_vpc.yemi_logready_vpc.id
  cidr_block              = var.public_subnet_az1b_cidr
  availability_zone       = "us-east-1b" # Change this to your desired availability zone
  map_public_ip_on_launch = true

  depends_on = [aws_vpc.yemi_logready_vpc,
  aws_internet_gateway.yemi_logready_igw]

  tags = {
    Name = "yemi-logready-public-az1b"
  }
}

# Create a Private app subnet in AZ 1a in the VPC.
# Ensure you name the subnet to private_app_subnet-az1a to match the naming convention.
resource "aws_subnet" "private_app_subnet_az1a" {
  vpc_id                  = aws_vpc.yemi_logready_vpc.id
  cidr_block              = var.private_app_subnet_az1a_cidr
  availability_zone       = "us-east-1a" # Change this to your desired availability zone
  map_public_ip_on_launch = false        # Set to false for private subnets ( Note: Private subnets should not have public IPs assigned to instances by default.)

  depends_on = [aws_vpc.yemi_logready_vpc,
  aws_internet_gateway.yemi_logready_igw]

  tags = {
    Name = "yemi-logready-private-az1a"
  }
}

# Create a Private app subnet in AZ 1b in the VPC.
# Ensure you name the subnet to private_app_subnet-az1b to match the naming convention.
resource "aws_subnet" "private_app_subnet_az1b" {
  vpc_id                  = aws_vpc.yemi_logready_vpc.id
  cidr_block              = var.private_app_subnet_az1b_cidr
  availability_zone       = "us-east-1b" # Change this to your desired availability zone
  map_public_ip_on_launch = false        # Set to false for private subnets ( Note: Private subnets should not have public IPs assigned to instances by default.)

  depends_on = [aws_vpc.yemi_logready_vpc,
  aws_internet_gateway.yemi_logready_igw]

  tags = {
    Name = "yemi-logready-private-az1b"
  }
}

#Create AWS EIP for NAT Gateway in the public subnet of AZ 1a.
# Ensure you name the EIP to nat_gateway_eip-az1a to match the naming convention.
resource "aws_eip" "yemi-logready-nat_gateway_eip" {
  domain = "vpc"

  tags = {
    Name = "yemi-logready-nat-gateway-eip"
  }
}

# Create a NAT Gateway in the public subnet of AZ 1a.
# Ensure you name the NAT Gateway to nat_gateway-az1a to match the naming convention.
resource "aws_nat_gateway" "yemi-logready-nat_gateway" {
  allocation_id = aws_eip.yemi-logready-nat_gateway_eip.id
  subnet_id     = aws_subnet.yemi-logready_public_az1a.id

  tags = {
    Name = "yemi-logready-nat-gateway"
  }

  depends_on = [aws_vpc.yemi_logready_vpc,
  aws_internet_gateway.yemi_logready_igw]
}

# Create a Public Route Table for the public subnets.
# Ensure you name the route table to public_route_table-az1a to match the naming convention.
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.yemi_logready_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.yemi_logready_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# associate the public route table with the public subnets in AZ 1a and AZ 1b.
resource "aws_route_table_association" "public_subnet_association_az1a" {
  subnet_id      = aws_subnet.yemi-logready_public_az1a.id
  route_table_id = aws_route_table.public_route_table.id
}

# associate the public route table with the public subnets in AZ 1a and AZ 1b.
resource "aws_route_table_association" "public_subnet_association_az1b" {
  subnet_id      = aws_subnet.yemi-logready_public_az1b.id
  route_table_id = aws_route_table.public_route_table.id
}
# Create a Private Route Table for the private subnets.
# Ensure you name the route table to private_route_table-az1a to match the naming convention.
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.yemi_logready_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.yemi-logready-nat_gateway.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}

# associate the private route table with the private app subnets in AZ 1a
resource "aws_route_table_association" "private_app_subnet_association_az1a" {
  subnet_id      = aws_subnet.private_app_subnet_az1a.id
  route_table_id = aws_route_table.private_route_table.id
}
# associate the private route table with the private app subnets in AZ 1b
resource "aws_route_table_association" "private_app_subnet_association_az1b" {
  subnet_id      = aws_subnet.private_app_subnet_az1b.id
  route_table_id = aws_route_table.private_route_table.id
}
