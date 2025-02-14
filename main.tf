provider "aws" {
  region = "us-east-1"  # Change to your region
}
# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Create a Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate Route Table with the Subnet
resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "flask_sg" {
  name        = "flask-security-group"
  description = "Allow Flask app and SSH access"

  # Allow SSH access (Restrict to your IP for security)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP (e.g., "192.168.1.1/32")
  }

  # Allow Flask app access (Default: Port 5000)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to your trusted IP if needed
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

resource "aws_instance" "flask1-ec2" {
  ami           = "ami-085ad6ae776d8f09c"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  key_name      = "terraform-key"
  security_groups = [aws_security_group.flask_sg.name]

  tags = {
    Name = "flask1-ec2"
  }
}
