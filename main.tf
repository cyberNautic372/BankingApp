provider "aws" {
  region = "ap-south-1"  # Mumbai region
}

resource "aws_instance" "test_server" {
  ami           = "ami-0f58b397bc5c1f2e8"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  tags = {
    Name = "test-server"  # Changed instance name to "test-server"
  }

  # Allow all inbound traffic from anywhere
  security_groups = ["allow-all-inbound"]
}

resource "aws_security_group" "allow-all-inbound" {
  name        = "allow-all-inbound"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to anywhere
  }
}
