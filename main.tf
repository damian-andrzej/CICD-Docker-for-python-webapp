provider "aws" {
  region = "us-east-1"  # Change to your region
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
}
resource "aws_instance" "flask1-ec2" {
  ami           = "ami-085ad6ae776d8f09c"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  key_name      = "damian-andrzej-ssh"

  security_groups = [aws_security_group.flask_sg]

  tags = {
    Name = "flask1-ec2"
  }
}
