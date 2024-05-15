provider "aws" {
  region = var.region
}

resource "random_string" "security_group_suffix" {
  length  = 8  # Adjust the length as needed
  special = false
}

resource "aws_instance" "test_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "masterkey"
  tags = {
    Name = "test-server"
  }

  count = 1  # Always create the instance

  security_groups = [aws_security_group.default.name]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/masterkey.pem")
    host        = self.public_ip
  }
}

resource "aws_security_group" "default" {
  name        = "custom-security-group-${random_string.security_group_suffix.result}"
  description = "Custom security group"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "test_server_public_ip" {
  value = aws_instance.test_server[*].public_ip
}
