# Resource Block
# Resource-1: Create VPC

resource "aws_vpc" "vpc-dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "vpc-dev"
  }
}

# Resource-2: Create Subnets
resource "aws_subnet" "vpc-dev-public-subnet-1" {
  vpc_id                  = aws_vpc.vpc-dev.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Resource-3: Internet Gateway
resource "aws_internet_gateway" "vpc-dev-igw" {
  vpc_id = aws_vpc.vpc-dev.id
}

# Resource-4: Route table
resource "aws_route_table" "vpc-dev-public-route-table" {
  vpc_id = aws_vpc.vpc-dev.id
}

# Resource-5: Create Route in route table for internet access
resource "aws_route" "vpc-dev-public-route" {
  route_table_id         = aws_route_table.vpc-dev-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-dev-igw.id

}

# Resource-6: Associate the route table with the subnet
resource "aws_route_table_association" "vpc-dev-public-route-table-association" {

  route_table_id = aws_route_table.vpc-dev-public-route-table.id
  subnet_id      = aws_subnet.vpc-dev-public-subnet-1.id
}

# Resource-7: create security group
resource "aws_security_group" "vpc-dev-sg" {

  name        = "vpc-dev-default-sg"
  description = "Dev vpc default sg"
  vpc_id      = aws_vpc.vpc-dev.id

  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
