provider "aws" {
  region = var.region  # Mumbai region
}

resource "aws_instance" "test_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }

  # Allow all inbound traffic from anywhere
  security_groups = var.allow_all_inbound ? ["allow-all-inbound"] : []
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
