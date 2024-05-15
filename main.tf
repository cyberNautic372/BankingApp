provider "aws" {
  region = var.region
}

resource "aws_instance" "test_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname testserver"
    ]
  }

  # Allow all inbound traffic from anywhere if required
  count = var.allow_all_inbound ? 1 : 0

  security_groups = var.allow_all_inbound ? ["allow-all-inbound"] : []
}

resource "aws_security_group" "allow-all-inbound" {
  count        = var.allow_all_inbound ? 1 : 0
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
