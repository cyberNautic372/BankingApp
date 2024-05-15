provider "aws" {
  region = var.region
}

resource "aws_instance" "test_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "masterkey"  # Use the existing key pair named "masterkey"
  tags = {
    Name = "test-server"
  }

  # Ensure the security group is created before referencing it
  depends_on = [aws_security_group.default]

  # Allow all inbound traffic from anywhere if required
  count = var.allow_all_inbound ? 1 : 0

  security_groups = var.allow_all_inbound ? [aws_security_group.default.name] : []
}

resource "aws_security_group" "default" {
  name        = "default"
  description = "Default security group"

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

output "test_server_public_ip" {
  value = aws_instance.test_server.public_ip
}
